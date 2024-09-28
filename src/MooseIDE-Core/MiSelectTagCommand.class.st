Class {
	#name : #MiSelectTagCommand,
	#superclass : #MiCommand,
	#category : #'MooseIDE-Core-Command'
}

{ #category : #default }
MiSelectTagCommand class >> defaultDescription [

	^ 'Select the tag that will be used to tag the current entities in this browser'
]

{ #category : #default }
MiSelectTagCommand class >> defaultIconName [

	^ #mooseDown
]

{ #category : #default }
MiSelectTagCommand class >> defaultName [

	^ 'Tag'
]

{ #category : #testing }
MiSelectTagCommand >> canBeExecuted [

	^ self context canTagEntities
]

{ #category : #executing }
MiSelectTagCommand >> execute [

	self newMenu openWithSpecAtPointer
]

{ #category : #'instance creation' }
MiSelectTagCommand >> newMenu [

	^ SpMenuPresenter new
		  addGroup: [ :group |
			  self tagsList do: [ :tag |
					  group addItem: [ :item |
							  item
								  name: tag name;
								  icon: (self application iconForTag: tag);
								  action: [ self selectedTag: tag ];
								  yourself ] ] ];
		  yourself
]

{ #category : #accessing }
MiSelectTagCommand >> selectedTag: aTag [

	context selectedTag: aTag
]

{ #category : #accessing }
MiSelectTagCommand >> tagsList [

	^ self context tagList
]
