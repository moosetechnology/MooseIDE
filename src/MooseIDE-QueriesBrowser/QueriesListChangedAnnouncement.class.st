"
When the query list presenter of `MiQueriesListPresenter` changes, I announce that. This is insteresting for the configuration presenters that need to know which are the current query list items. See my subscribers for more info.
"
Class {
	#name : #QueriesListChangedAnnouncement,
	#superclass : #Announcement,
	#category : #'MooseIDE-QueriesBrowser-Announcements'
}
