Class {
	#name : #MiCreateDynamicTagQueryCommand,
	#superclass : #MiCommand,
	#category : #'MooseIDE-QueriesBrowser-Commands'
}

{ #category : #default }
MiCreateDynamicTagQueryCommand class >> defaultDescription [

	^ 'Create a dynamic tag using this query'
]

{ #category : #default }
MiCreateDynamicTagQueryCommand class >> defaultIconName [

	^ #mooseEditor
]

{ #category : #default }
MiCreateDynamicTagQueryCommand class >> defaultName [

	^ 'Create Dynamic Tag'
]

{ #category : #executing }
MiCreateDynamicTagQueryCommand >> execute [

	self context query isValid ifFalse: [
		self inform: 'Cannot create tag with invalid query'.
		^ self ].

	self openTagCreationPage
]

{ #category : #executing }
MiCreateDynamicTagQueryCommand >> openTagCreationPage [

	| tagCreationPage |

	tagCreationPage := MiTagBrowser open
		                   openTagCreationForm;
		                   tagCreationForm.
	tagCreationPage
		setIntentForm;
		updateQueryList.

	tagCreationPage queryList selectItem: self context query
]
