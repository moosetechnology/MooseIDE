"
I am a dynamic tag creation form.
"
Class {
	#name : #MiDynamicTagCreationForm,
	#superclass : #MiPresenter,
	#instVars : [
		'cancelButton',
		'submitButton',
		'tagList'
	],
	#category : #'MooseIDE-Dependency-HierarchicalMap'
}

{ #category : #initialization }
MiDynamicTagCreationForm >> addTag: aTag [

	tagList model items add: aTag.
	tagList refresh
]

{ #category : #initialization }
MiDynamicTagCreationForm >> checkFormInputs [

	tagList selectedItems ifEmpty: [ ^ false ].
	^ true
]

{ #category : #initialization }
MiDynamicTagCreationForm >> connectPresenters [

	cancelButton action: [ self owner closeTagCreationForm ].
	submitButton action: [ self submit ]
]

{ #category : #initialization }
MiDynamicTagCreationForm >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
			 add: (SpBoxLayout newLeftToRight
					  hAlignCenter;
					  add: 'Select tags' asPresenter;
					  yourself)
			 expand: false;
			 add: tagList
			 expand: true
			 fill: true
			 padding: 10;
			 add: (SpBoxLayout newLeftToRight
					  add: cancelButton;
					  add: submitButton;
					  yourself)
			 expand: false;
			 yourself)
]

{ #category : #initialization }
MiDynamicTagCreationForm >> initializePresenters [

	(tagList := self newList)
		beMultipleSelection;
		display: [ :dt | dt name ];
		displayIcon: [ :dt | MiTagBrowserModel iconForTag: dt ].
	submitButton := self newButton label: 'Add'.
	cancelButton := self newButton label: 'Cancel'.
	self initializeLayout
]

{ #category : #initialization }
MiDynamicTagCreationForm >> removeTag: aTag [

	tagList model items remove: aTag.
	tagList refresh
]

{ #category : #initialization }
MiDynamicTagCreationForm >> reset [

	tagList unselectAll.
]

{ #category : #initialization }
MiDynamicTagCreationForm >> setTags [

	tagList items: (self root application itemsFor: MiDynamicTag) asMooseGroup.
	tagList refresh
]

{ #category : #initialization }
MiDynamicTagCreationForm >> submit [

	self checkFormInputs ifFalse: [ ^ self ].
	self owner addDynamicTags: tagList selectedItems.
	self reset.
	self owner closeTagCreationForm
]

{ #category : #accessing }
MiDynamicTagCreationForm >> tagList [

	^ tagList
]

{ #category : #accessing }
MiDynamicTagCreationForm >> tagList: anObject [

	^ tagList := anObject
]
