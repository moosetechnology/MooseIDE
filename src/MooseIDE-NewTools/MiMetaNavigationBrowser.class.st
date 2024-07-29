"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  State a one line summary. For example, ""I represent a paragraph of text"".

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	model:		<Object>
	properties:		<Object>


    Implementation Points
"
Class {
	#name : #MiMetaNavigationBrowser,
	#superclass : #StPresenter,
	#instVars : [
		'navigation',
		'model',
		'activationBlock',
		'activateOnSingleClick',
		'properties',
		'entitiesColumn'
	],
	#category : #'MooseIDE-NewTools-Inspector tabs'
}

{ #category : #specs }
MiMetaNavigationBrowser class >> buildCommandsGroupWith: presenter forRoot: aCmCommandsGroup [
	aCmCommandsGroup
		beDisplayedAsGroup;
		register: (StInspectorInspectSelectedCommand forSpecContext: presenter)
]

{ #category : #layout }
MiMetaNavigationBrowser class >> defaultLayout [

	^ SpPanedLayout newVertical
		  positionOfSlider: 65 percent;
		  add: #navigation;
		  add: #properties;
		  yourself
]

{ #category : #initialization }
MiMetaNavigationBrowser >> activateOnSingleClick [
	navigation activateOnSingleClick
]

{ #category : #accessing }
MiMetaNavigationBrowser >> activateOnSingleClick: anObject [

	activateOnSingleClick := anObject
]

{ #category : #action }
MiMetaNavigationBrowser >> filterEmptyValues: entities [

	^ entities select: [ :each | 
		  each value isCollection
			  ifTrue: [ each value isNotEmpty ]
			  ifFalse: [ true ] ]
]

{ #category : #initialization }
MiMetaNavigationBrowser >> hasOutputActivationPort [

	^ true
]

{ #category : #initialization }
MiMetaNavigationBrowser >> iconBlock [

	^ [ :el | el value mooseIcon ]
]

{ #category : #initialization }
MiMetaNavigationBrowser >> initializePresenters [

	| items |
	navigation := self newTreeTable.
	items := self filterEmptyValues: (self itemsFor: self model).
	entitiesColumn := SpStringTableColumn new
		                  evaluated: [ :el |
			                  String streamContents: [ :str |
					                  self printEntry: el on: str ] ];
		                  beSortable;
		                  yourself.
	navigation addColumn: (SpCompositeTableColumn new
			 title: 'Entities';
			 addColumn: (SpImageTableColumn new
					  width: 20;
					  evaluated: self iconBlock;
					  yourself);
			 addColumn: entitiesColumn).
	navigation children: [ :anEntity | self itemsFor: anEntity value ].
	navigation
		contextMenu: [ self rootCommandsGroup asMenuPresenter ];
		items: items.
	navigation whenActivatedDo: [ :selection |
		self inspectorObjectContextPresenter owner
			changeSelection: selection selectedItem value
			from: self inspectorObjectContextPresenter ].
	properties := MiPropertyExtension on: self model
]

{ #category : #initialization }
MiMetaNavigationBrowser >> inspectorObjectContextPresenter [

	^ self owner owner owner owner
]

{ #category : #initialization }
MiMetaNavigationBrowser >> itemsFor: anEntity [

	^ anEntity isMooseObject
		  ifTrue: [ anEntity miMetaNavigationItems ]
		  ifFalse: [ {  } ]
]

{ #category : #accessing }
MiMetaNavigationBrowser >> model [
	^ model
]

{ #category : #accessing }
MiMetaNavigationBrowser >> model: anObject [
	model := anObject
]

{ #category : #initialization }
MiMetaNavigationBrowser >> outputActivationPort [
	^ (SpActivationPort newPresenter: self)
		yourself
]

{ #category : #initialization }
MiMetaNavigationBrowser >> printEntry: el on: aStream [

	aStream nextPutAll: el key.
	(el value isBlock not and: [ el value mooseName ~= el key ])
		ifFalse: [ ^ self ].
	aStream nextPutAll: ': '.
	aStream nextPutAll: el value mooseName
]

{ #category : #accessing }
MiMetaNavigationBrowser >> selectedItem [
	
	^ navigation selection selectedItem value
]

{ #category : #initialization }
MiMetaNavigationBrowser >> selectedObject [
	^ navigation selection selectedItem value
]

{ #category : #'accessing - model' }
MiMetaNavigationBrowser >> setModelBeforeInitialization: anInspectionModel [ 

	model := anInspectionModel
]

{ #category : #initialization }
MiMetaNavigationBrowser >> whenActivatedDo: aBlock [
	activationBlock := aBlock
]
