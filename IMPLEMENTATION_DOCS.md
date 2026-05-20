# Implementation Documentation: Main Event Display on Home Page

## Overview
This feature adds functionality to display the user's main upcoming event on the home page, with a clickable card that navigates to the event details page.

## Changes Made

### 1. Controller Changes
- **File**: `app/controllers/pages_controller.rb`
- Added logic to fetch the user's main event:
  - For hosts: Their hosted events that are active and upcoming
  - For participants: Events they are participating in that are active and upcoming
  - The main event is determined as the closest upcoming event

### 2. View Changes
- **File**: `app/views/pages/home.html.erb`
- Added a new section to display the main event card for logged-in users
- The event card displays:
  - Event name
  - Event description
  - Event date
  - A button to navigate to the event details page

## Implementation Details

### Controller Logic
The controller was updated to fetch the main event for logged-in users:

```ruby
# Fetch the current user's main event (closest upcoming event)
if logged_in?
  @main_event = current_user.hosted_events.active.upcoming.first || 
                current_user.events.joins(:event_participants).where(event_participants: { user_id: current_user.id }).active.upcoming.first
end
```

This logic prioritizes:
1. Hosted events first (as the host would be most interested in their own events)
2. Events the user is participating in as a guest

### View Implementation
The home page view was updated to display the main event card only when a user is logged in and has a main event:

```erb
<% if logged_in? && @main_event %>
  <div class="event-card">
    <h3><%= @main_event.name %></h3>
    <p><%= @main_event.description %></p>
    <p>Date: <%= @main_event.target_date.strftime("%d/%m/%Y") %></p>
    <%= link_to "View Event", event_path(@main_event) %>
  </div>
<% end %>
```

### Navigation Implementation
Clicking the "View Event" button navigates to the event show page using the standard Rails path helper:
```erb
<%= link_to event_path(@main_event), class: "btn-primary w-full block text-center" do %>
  <span>Ver Evento</span>
<% end %>
```

## Technical Details

### Event Selection Logic
The system selects the main event using this priority:
1. First, it looks for events where the user is the host
2. If no hosted events are found, it looks for events where the user is a participant

### Data Fetching
The implementation uses:
- `current_user.hosted_events.active.upcoming.first` - Gets the first active upcoming event where the user is the host
- `current_user.events.joins(:event_participants).where(event_participants: { user_id: current_user.id }).active.upcoming.first` - Gets the first active upcoming event where the user is a participant

### User Experience
- For logged-in users, the main event is prominently displayed
- The event card provides a direct link to the event details page
- Non-logged-in users see the standard home page without the event card

## Testing
The implementation has been tested to ensure:
- Event cards are only shown to logged-in users
- The correct event is selected based on priority
- Navigation to event pages works correctly
- The UI is responsive and user-friendly

## Future Considerations
- Add caching for improved performance
- Consider adding a preference for which event to display
- Add support for multiple event display