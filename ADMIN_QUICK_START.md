# 🔐 Admin Portal Quick Start Guide

## Accessing the Admin System

### Method 1: Direct Route Navigation
From anywhere in the app, navigate to:
```
/admin-login
```

### Method 2: Deep Link
Use deep linking:
```
mindpath://admin-login
```

### Method 3: From Flutter App Code
```dart
Navigator.pushNamed(context, '/admin-login');
```

---

## 🔑 Admin Credentials

### Super Admin Account (Full Access)
```
Email: superadmin@mindpath.com
Password: SuperAdmin@2024
```
**Permissions:** All admin functions, user management, counselor verification, resource publishing, analytics

### Admin Account (Standard Access)
```
Email: admin@mindpath.com
Password: Admin@2024
```
**Permissions:** User management, counselor verification, resource review, basic analytics

---

## 📱 Admin Portal Navigation

### Login Screen (`/admin-login`)
Entry point for all admin access
- Email field with validation
- Password field with show/hide toggle
- Demo credentials displayed for testing
- Error messages for invalid login

### Main Dashboard (`/admin-dashboard`)
Central hub with overview and quick access
- Summary statistics
- Navigation to all management sections
- Current admin information
- Last login timestamp

### User Management (`/admin-users`)
Complete user account administration
- Search users by name/email
- Filter by status: All, Active, Suspended
- View user detail profile
- Suspend/Activate accounts
- Track recovery metrics (days sober, streaks)

### Counselor Management (`/admin-counselors`)
Counselor verification and oversight
- Search by name/email/specialization
- Filter by status: Verified, Pending
- Review counselor profiles
- Verify pending counselors
- Deactivate counselors if needed
- Track performance (rating, client count)

### Resource Management (`/admin-resources`)
Control recovery resources
- Search by title/description/source
- Filter by status: Published, Draft
- View resource details with sources
- Publish/Unpublish resources
- Delete invalid resources
- Track metrics (views, rating)

### Analytics Dashboard (`/admin-analytics`)
Platform-wide insights and metrics
- Key performance indicators
- User statistics and engagement
- Recovery metrics
- Growth tracking
- Recommendations for improvements
- Refresh data in real-time

### Support Tickets (`/admin-support`)
User support issue management
- Search by subject/user
- Filter by status and priority
- View full ticket details
- Update ticket status
- Add comments to tickets
- Track resolution time

---

## 🎯 Common Admin Tasks

### Task 1: Verify a New Counselor
1. Navigate to `/admin-counselors`
2. Click on the "Pending" tab
3. Find the counselor needing verification
4. Click "View Profile"
5. Click "Verify Counselor" button
6. Confirm in the dialog

### Task 2: Suspend a User Account
1. Go to `/admin-users`
2. Search for the user
3. Click "View Details" on their card
4. Click "Suspend User"
5. Confirm the suspension

### Task 3: Publish a Draft Resource
1. Navigate to `/admin-resources`
2. Click on the "Draft" tab
3. Find the resource
4. Click "View" to review
5. Confirm publication
6. Resource is now live

### Task 4: Review Analytics
1. Go to `/admin-analytics`
2. Review key metrics
3. Check user engagement breakdown
4. Read recommendations
5. Click refresh to update data

### Task 5: Manage Support Tickets
1. Navigate to `/admin-support`
2. View open tickets
3. Click on a ticket to see details
4. Click "In Progress" to claim ticket
5. Add comments as needed
6. Click "Mark as Resolved" when done

---

## 🔒 Security Features

- ✅ Password-protected login
- ✅ Session management via admin user object
- ✅ Confirmation dialogs for destructive actions
- ✅ Role-based access (super_admin vs admin)
- ✅ Audit trail ready (timestamps on all actions)
- ✅ Input validation on all forms

---

## 🔄 Status & State Management

### User Status Codes
- `active` - User is actively using the app
- `inactive` - User hasn't logged in recently
- `suspended` - Account is temporarily disabled
- `archived` - Account marked for historical record

### Counselor Status
- `verified` - Counselor credentials approved
- `pending` - Awaiting credential verification
- `active` - Currently accepting clients
- `inactive` - Not available for new assignments

### Resource Status
- `published` - Live and visible to users
- `draft` - In review, not visible yet
- `archived` - No longer promoted

### Ticket Status
- `open` - New ticket awaiting assignment
- `in_progress` - Being actively handled
- `resolved` - Issue fixed, awaiting closure
- `closed` - Ticket archived

### Ticket Priority
- `low` - General inquiry or feedback
- `medium` - Issues affecting experience
- `high` - Critical problems affecting app use
- `critical` - System down or severe harm risk

---

## 📊 Data Overview

### Sample Data Included
The system comes with realistic demo data:
- 2 admin users (super_admin + admin)
- 2 app users with recovery metrics
- 2 counselors (1 verified, 1 pending)
- 2 recovery resources with sources
- 1 support ticket with comments

This allows immediate testing without backend setup.

---

## 🔧 Troubleshooting

### Can't Login?
- Check credentials exactly (case-sensitive)
- Verify email format: `superadmin@mindpath.com`
- Ensure password is: `SuperAdmin@2024` or `Admin@2024`

### Data Not Updating?
- Click refresh button in top-right corner
- Data is cached in memory (mock service)
- Changes persist for current session

### Navigation Not Working?
- Ensure routes are registered in main.dart
- Check that you're using correct route: `/admin-xxx`
- Verify all admin files are in `lib/admin/` directory

### Screens Loading Slowly?
- Admin service simulates 300-500ms network delays
- This is intentional for realistic UX testing
- Will be replaced with actual API calls in production

---

## 🚀 Performance Tips

1. **Use Search Filters**: Narrow down data before viewing
2. **Review Before Actions**: Always check details before suspend/delete
3. **Batch Operations**: Handle multiple similar items together
4. **Monitor Analytics**: Check regularly for trends and issues
5. **Response Time**: Allow service delays when testing

---

## 📈 Future Admin Features (Planned)

- [ ] Advanced analytics with charts and graphs
- [ ] Bulk import/export operations
- [ ] Admin action audit logs
- [ ] Email notifications for alerts
- [ ] Advanced filtering and saved searches
- [ ] Customizable dashboard
- [ ] Automated report generation
- [ ] Real-time notification dashboard
- [ ] User activity timeline
- [ ] Content recommendation engine

---

## 💡 Admin Best Practices

### User Management
- Review user profiles monthly
- Monitor recovery metrics
- Suspend accounts only when necessary
- Keep communication channels open

### Counselor Oversight
- Verify all credentials before approval
- Monitor client satisfaction ratings
- Track session frequency and quality
- Provide feedback for improvement

### Resource Quality
- Review sources before publishing
- Ensure content is current and accurate
- Remove outdated resources promptly
- Monitor user ratings and feedback

### Support
- Respond to critical tickets first
- Track resolution time
- Use tickets to identify common issues
- Provide follow-up support

---

## 📞 Support

For issues or questions about the admin system:
1. Check [ADMIN_SYSTEM_DOCUMENTATION.md](./ADMIN_SYSTEM_DOCUMENTATION.md) for detailed info
2. Review the code comments in each admin file
3. Check [ADMIN_SYSTEM_COMPLETION.md](./ADMIN_SYSTEM_COMPLETION.md) for full feature list

---

## ✅ Admin Ready!

Your admin portal is now ready to use. Start by logging in with the demo credentials and exploring all the management features.

**Happy administering! 🎉**
