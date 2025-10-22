Class {
	#name : 'MiCreateDynamicTagQueryCommand',
	#superclass : 'MiCommand',
	#category : 'MooseIDE-QueriesBrowser-Commands',
	#package : 'MooseIDE-QueriesBrowser',
	#tag : 'Commands'
}

{ #category : 'default' }
MiCreateDynamicTagQueryCommand class >> defaultDescription [

	^ 'Create a dynamic tag using this query'
]

{ #category : 'default' }
MiCreateDynamicTagQueryCommand class >> defaultIconName [

	^ #mooseEditor
]

{ #category : 'default' }
MiCreateDynamicTagQueryCommand class >> defaultName [

	^ 'Create Dynamic Tag'
]

{ #category : 'executing' }
MiCreateDynamicTagQueryCommand >> execute [

	self context query isValid ifFalse: [
			self application inform: 'Cannot create tag with invalid query'.
			^ self ].

	self openTagCreationPage
]

{ #category : 'executing' }
MiCreateDynamicTagQueryCommand >> openTagCreationPage [
	"Return the tag creation page for test purposes. Not needed in the application"
	| tagCreationPage |

	tagCreationPage := MiTagBrowser new
		                   createTag.
	tagCreationPage
		setIntentForm;
		updateQueryList.

	tagCreationPage queryList selectItem: (self context query).
	
	^tagCreationPage 
]
