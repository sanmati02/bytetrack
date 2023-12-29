## Team Members

Member 1 Name: Nicole Lin

Member 1 UNI: nsl2126

Member 2 Name: Sanmati Choudhary

Member 2 UNI: sc4789

Member 3 Name: Preethi Prakash

Member 3 UNI: pp2769

Member 4 Name: Samantha Burak

Member 4 UNI: sb4189

## Instructions

### Section 1: Understanding how the app works

- Click on the Heroku link to see the app live in action.

- User Management: ByteTrack allows for every user to have their own database of job applications. When first clicking on the heroku deployment link, the user is brought to the welcome page where the user can either sign up or log in. If the user does not have an account, they can make an account by clicking on the sign up button. This page will prompt for an email, password with 6 characters minimum, and confirm the password. If the password is less than 6 characters or the confirmed password is not the same as the initial password, then there will be a warning, and the user will not be able to sign up. If the user clicked on the log in button on the welcome page, then the user is prompted to enter their existing login info (email & password). If either the email or password are incorrect, then a warning will show up and the user will not be able to log in. Once on the ByteTrack homepage, the user can sign out at anytime by clicking on the Sign Out button in the navbar.
   
- Filter: On the left sidebar on the ByteTrack homepage, the user can filter jobs by priority and final decision. The user can select priority, final decision, or both, and click the "Apply Filters" button which will then update all columns (Applied, Completed OAs, Completed Interviews, Heard Back) on the homepage. The user can also filter by task list which includes interview upcoming or OA pending or both. Interview upcoming or OA pending is determined by the OA Deadline and Interview Deadline fields, respectively. If the OA deadline is a future date, then the company title will have a green badge that says "OA Pending" next to it. Similarly, if the Interview Date is a future date, then the company title will have a blue badge that says "Interview Upcoming." The Task List filter will filter these badge categories for the user.

- Sorting: On the left sidebar on the ByteTrack homepage, the user can sort by company title (alphabetically ascending/descending), date applied (newest/oldest), priority (high/low), final decision (best/worst), and date applied (oldest to newest). 

- Searching: On the left sidebar on the ByteTrack homepage, the user can search by company title (case insensitive).

- Clear Filter, Sorting, Searching: On the left sidebar on the ByteTrack homepage, the user can clear all filters, sorting, and searching by clicking the "Clear All" button. This resets the entire board to an un-filtered, un-sorted, and un-searched state.

- Adding: The user can click the "Add new job" button on the ByteTrack homepage which will bring the user to a new page where they can add information such as company, job title, location, skills, priority, final decision, date applied, OA status, OA deadline, OA confidence rating, OA Notes, interview status, interview date, interview confidence rating, and interview notes. When a user starts entering values for company title and job title, there are dropdowns that help the user autocomplete those fields based on what other users in the database have entered in for their company titles and job titles. For example, if a user types in G and other users in the database have entered in Google and Geico for their company titles, then the autocomplete dropdown will include Google and Geico. If a user does not fill out the Company, Job Title, or Date Applied fields, the user cannot add a new job and a red alert will pop up at the top of the page, telling the user that those specific fields were not filled out. Additionally, if the user puts a future date for the Date Applied field, a red alert will pop up saying that a future date cannot be put. If the user does not fill out any of the rest of the fields, that field will default to a placeholder value. After filling out the necessary fields, a card with the comapny name, date applied, and priority will show up on the homepage under the corresponding column. If date applied is filled out, the card will be placed under the Applied column. If the OA status is Complete, the card will be placed under the Completed OA column. If the interview status is Complete, then the card will be placed under the Completed Interview column. If the Final Decision is not N/A, the card will be placed under the Heard Back column. If the Final Decision is "Received Offer," the card will be outlined in green, and if the Final Decision is "Rejected," the card will be outlined in red.

- Editing/Deleting: The user can click on the "Edit" button once on the details page of a job. The edit page has input fields that are prepopulated with the existing information for that specific job. The user can either change existing fields or replace the placeholder values with their new desired values. Then, the user can click on the "Update Job Info" button which will bring the user back to the details page of the job. The top of the screen will have a blue alert bar that indicates the job was successfully updated. If the user edits the status of a job (i.e., OA completed, interview completed, etc.) and goes back to the homepage, the job card will automatically move to the corresponding column. From the details page, the user can delete a job by clicking on the "Delete" button. A popup notice will appear prompting the user "Are you sure?" After deleting the job, the user is brought back to the homepage, and the top of the screen will have a blue alert bar that indicates the job was successfully deleted. The job will not appear in the any of the columns on the homepage anymore.

- Reminders: When an OA deadline for a specific company is less than 3 days away, there will be a yellow alert bar on top of the ByteTrack homepage notifying the user that they have an OA for that company due in less than 3 days away. The behavior is also applied to Interview Dates. 

- Statistics Page: When the use clicks on the "See stats page" button on the homepage, it will lead them to an Application Statistics page. The summary consists of information like how many total jobs a user applied to this season, number of interviews completed, OA confidence percentage, etc. The next section shows a line graph of how many applications the user has submitted per day over the course of the last 2 months. The three pie charts show Overview of OA Statuses, Overview of Interview Statuses, and Overview of Decision Outcomes. The last two bar charts show the number of OAs and number of interviews for each rating of confidence (1-5).

### Section 2: Testing the product

1. Clone the bytetrack git repository onto your local computer.

2. Open the terminal and navigate to the bytetrack directory.

3. Run bundle exec cucumber to see all the scenarios pass. Our coverage is 100% for all files.

4. Run bundle exec rspec to see all the rspec tests pass. Our coverage is 100% for all files.

## Links

Heroku Deployment Link: https://creepy-shadow-97890-ad44f76abd37.herokuapp.com/

Github Repo Link: https://github.com/preethiprakash1/bytetrack
