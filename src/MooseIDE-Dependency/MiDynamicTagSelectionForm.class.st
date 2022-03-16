"
I am a dynamic tag creation form.
"
Class {
	#name : #MiDynamicTagSelectionForm,
	#superclass : #MiPresenter,
	#instVars : [
		'cancelButton',
		'submitButton',
		'tagList'
	],
	#category : #'MooseIDE-Dependency-DistributionMap'
}

{ #category : #initialization }
MiDynamicTagSelectionForm >> addTag: aTag [

	tagList model items add: aTag.
	tagList refresh
]

{ #category : #initialization }
MiDynamicTagSelectionForm >> checkFormInputs [

	tagList selectedItems ifEmpty: [ ^ false ].
	^ true
]

{ #category : #initialization }
MiDynamicTagSelectionForm >> connectPresenters [

	cancelButton action: [ self owner closeTagCreationForm ].
	submitButton action: [ self submit ]
]

{ #category : #initialization }
MiDynamicTagSelectionForm >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
			 add: (SpBoxLayout newLeftToRight
					  hAlignCenter;
					  add: 'Available tags:' asPresenter;
					  yourself)
			 expand: false;
			 add: tagList;
			 add: (SpBoxLayout newLeftToRight
					  add: cancelButton;
					  add: submitButton;
					  yourself)
			 expand: false;
			 yourself)
]

{ #category : #initialization }
MiDynamicTagSelectionForm >> initializePresenters [

	(tagList := self newList)
		beMultipleSelection;
		display: [ :dt | dt name ];
		displayIcon: [ :dt | MiTagBrowserModel iconForTag: dt ].
	submitButton := self newButton label: 'Add'.
	cancelButton := self newButton label: 'Cancel'.
	self initializeLayout
]

{ #category : #initialization }
MiDynamicTagSelectionForm >> removeTag: aTag [

	tagList model items remove: aTag.
	tagList refresh
]

{ #category : #initialization }
MiDynamicTagSelectionForm >> reset [

	tagList unselectAll.
]

{ #category : #initialization }
MiDynamicTagSelectionForm >> setTags [

	tagList items: ((self root application itemsFor: MiDynamicTag)
		 \ self owner model dynamicTags) asMooseGroup.
	tagList refresh
]

{ #category : #initialization }
MiDynamicTagSelectionForm >> submit [

	self checkFormInputs ifFalse: [ ^ self ].
	self owner addDynamicTags: tagList selectedItems.
	self reset.
	self owner closeTagCreationForm
]

{ #category : #accessing }
MiDynamicTagSelectionForm >> tagList [

	^ tagList
]

{ #category : #accessing }
MiDynamicTagSelectionForm >> tagList: anObject [

	^ tagList := anObject
]
