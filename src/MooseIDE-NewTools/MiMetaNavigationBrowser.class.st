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
	#traits : 'SpTActivable',
	#classTraits : 'SpTActivable classTrait',
	#instVars : [
		'navigation',
		'model',
		'properties',
		'actionBar',
		'shouldShowPropertiesPane'
	],
	#category : #'MooseIDE-NewTools-Inspector tabs'
}

{ #category : #specs }
MiMetaNavigationBrowser class >> buildCommandsGroupWith: presenter forRoot: aCmCommandsGroup [

	aCmCommandsGroup
		beDisplayedAsGroup;
		register:
			(MiInspectCommand forSpecContext: presenter window presenter);
		register:
			(MiPropagateCommand forSpecContext: presenter window presenter)
]

{ #category : #'as yet unclassified' }
MiMetaNavigationBrowser class >> defaultShouldShowPropertiesPane [

	^ false
]

{ #category : #'private - actions' }
MiMetaNavigationBrowser >> activate [

	activationAction cull:
		(SpActivatedSelection newValue: navigation selectedItem value)
]

{ #category : #api }
MiMetaNavigationBrowser >> activateOnDoubleClick [

	navigation activateOnDoubleClick
]

{ #category : #api }
MiMetaNavigationBrowser >> activateOnSingleClick [

	navigation activateOnSingleClick
]

{ #category : #'private - display' }
MiMetaNavigationBrowser >> childrenFor: anEntity [

	^ self itemsFor: anEntity value
]

{ #category : #layout }
MiMetaNavigationBrowser >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: navigation;
		  add: actionBar expand: false;
		  yourself
]

{ #category : #layout }
MiMetaNavigationBrowser >> hidePropertiesPane [

	self layout remove: properties
]

{ #category : #'private - display' }
MiMetaNavigationBrowser >> iconBlock [

	^ [ :el | el value mooseIcon ]
]

{ #category : #initialization }
MiMetaNavigationBrowser >> initialize [

	super initialize.
	activationAction := SpActivationHolder new.
	self shouldShowPropertiesPane ifTrue: [ self showPropertiesPane ]
]

{ #category : #initialization }
MiMetaNavigationBrowser >> initializeNavigationTreeTable [

	navigation := self newTreeTable.
	navigation
		beResizable;
		activateOnSingleClick;
		addColumn: ((SpCompositeTableColumn title: 'Entities')
				 sortFunction: [ :entry | self printEntry: entry ] ascending;
				 addColumn: (SpImageTableColumn new
						  evaluated: self iconBlock;
						  width: 20;
						  yourself);
				 addColumn: (SpStringTableColumn new
						  evaluated: [ :el | self printEntry: el ];
						  beSortable;
						  yourself)).
	navigation
		children: [ :anEntity | self childrenFor: anEntity ];
		contextMenu: [ self rootCommandsGroup asMenuPresenter ];
		items: (self itemsFor: self model);
		whenActivatedDo: [ self activate ]
]

{ #category : #initialization }
MiMetaNavigationBrowser >> initializePresenters [

	self initializeNavigationTreeTable.

	actionBar := self newActionBar.
	actionBar add: (self newToggleButton
			 label: 'Properties';
			 help: 'Show properties panel - May be long to compute';
			 whenActivatedDo: [ self showPropertiesPane ];
			 whenDeactivatedDo: [ self hidePropertiesPane ];
			 yourself)
]

{ #category : #'private - display' }
MiMetaNavigationBrowser >> itemsFor: anObject [

	^ anObject miMetaNavigationItems
]

{ #category : #accessing }
MiMetaNavigationBrowser >> model [
	^ model
]

{ #category : #accessing }
MiMetaNavigationBrowser >> model: anObject [
	model := anObject
]

{ #category : #'private - display' }
MiMetaNavigationBrowser >> printEntry: anAssociation [

	^ String streamContents: [ :s |
		  s << anAssociation key.
		  (anAssociation value isBlock not and: [
			   anAssociation value mooseName ~= anAssociation key ]) ifFalse: [
			  ^ s contents ].
		  s << ': '.
		  s << anAssociation value mooseName ]
]

{ #category : #accessing }
MiMetaNavigationBrowser >> selectedObject [

	^ navigation selection selectedItem value
]

{ #category : #'accessing - model' }
MiMetaNavigationBrowser >> setModelBeforeInitialization: anInspectionModel [ 

	model := anInspectionModel
]

{ #category : #testing }
MiMetaNavigationBrowser >> shouldShowPropertiesPane [
	"This is legacy. Not removed because it may be used? If so, it should be a setting. Else, removed"

	^ shouldShowPropertiesPane ifNil: [
		  self class defaultShouldShowPropertiesPane ]
]

{ #category : #layout }
MiMetaNavigationBrowser >> showPropertiesPane [

	properties ifNil: [ properties := MiPropertyExtension on: self model ].
	self layout add: properties
]
