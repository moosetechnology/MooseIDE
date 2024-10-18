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
		'entitiesColumn',
		'actionBar',
		'shouldShowPropertiesPane'
	],
	#category : #'MooseIDE-NewTools-Inspector tabs'
}

{ #category : #specs }
MiMetaNavigationBrowser class >> buildCommandsGroupWith: presenter forRoot: aCmCommandsGroup [
	aCmCommandsGroup
		beDisplayedAsGroup;
		register: (StInspectorInspectSelectedCommand forSpecContext: presenter)
]

{ #category : #'as yet unclassified' }
MiMetaNavigationBrowser class >> defaultShouldShowPropertiesPane [

	^ false
]

{ #category : #initialization }
MiMetaNavigationBrowser >> activateOnSingleClick [
	navigation activateOnSingleClick
]

{ #category : #accessing }
MiMetaNavigationBrowser >> activateOnSingleClick: anObject [

	activateOnSingleClick := anObject
]

{ #category : #initialization }
MiMetaNavigationBrowser >> addPropertiesPane [

	self layout add: properties
]

{ #category : #layout }
MiMetaNavigationBrowser >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newTopToBottom
				   add: #navigation;
				   yourself);
		  add: #actionBar expand: false;
		  yourself
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
	"navigation"
	navigation := self newTreeTable.
	navigation isResizable: true.
	items := self filterEmptyValues: (self itemsFor: self model).
	entitiesColumn := SpStringTableColumn new
		                  evaluated: [ :el | self printEntry: el ];
		                  beSortable;
		                  yourself.
	navigation addColumn: (SpCompositeTableColumn new
			 title: 'Entities';
			 sortFunction: [ :entry | self printEntry: entry ] ascending;
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
	"action bar"
	actionBar := self newActionBar add: (self newButton
			              label: 'Properties';
			              help: 'Show properties panel';
			              action: [ self toggleShouldShowPropertiesPane ];
			              yourself).
	"properties"
	properties := MiPropertyExtension on: self model.
	self shouldShowPropertiesPane ifTrue: [ self addPropertiesPane ]
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
MiMetaNavigationBrowser >> printEntry: anAssociation [

	^ String streamContents: [ :s |
		  s << anAssociation key.
		  (anAssociation value isBlock not and: [
			   anAssociation value mooseName ~= anAssociation key ]) ifFalse: [
			  ^ self ].
		  s << ': '.
		  s << anAssociation value mooseName ]
]

{ #category : #initialization }
MiMetaNavigationBrowser >> removePropertiesPane [

	self layout remove: properties
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
MiMetaNavigationBrowser >> shouldShowPropertiesPane [

	^ shouldShowPropertiesPane ifNil: [ self class defaultShouldShowPropertiesPane ]
]

{ #category : #initialization }
MiMetaNavigationBrowser >> toggleShouldShowPropertiesPane [

	^ self shouldShowPropertiesPane
		  ifTrue: [
			  shouldShowPropertiesPane := false.
			  self removePropertiesPane ]
		  ifFalse: [
			  shouldShowPropertiesPane := true.
			  self addPropertiesPane ]
]

{ #category : #initialization }
MiMetaNavigationBrowser >> whenActivatedDo: aBlock [
	activationBlock := aBlock
]
