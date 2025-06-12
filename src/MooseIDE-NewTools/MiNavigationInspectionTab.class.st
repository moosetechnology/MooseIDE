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
	#name : #MiNavigationInspectionTab,
	#superclass : #StPresenter,
	#traits : 'SpTActivable',
	#classTraits : 'SpTActivable classTrait',
	#instVars : [
		'navigation',
		'actionBar',
		'shouldShowPropertiesPane',
		'inspectedObject',
		'propertiesPane'
	],
	#category : #'MooseIDE-NewTools-Inspector tabs'
}

{ #category : #specs }
MiNavigationInspectionTab class >> buildCommandsGroupWith: presenter forRoot: aCmCommandsGroup [

	aCmCommandsGroup
		beDisplayedAsGroup;
		register:
			(MiInspectCommand forSpecContext: presenter window presenter);
		register:
			(MiPropagateCommand forSpecContext: presenter window presenter)
]

{ #category : #'as yet unclassified' }
MiNavigationInspectionTab class >> defaultShouldShowPropertiesPane [

	^ false
]

{ #category : #'private - actions' }
MiNavigationInspectionTab >> activate [

	activationAction cull:
		(SpActivatedSelection newValue: navigation selectedItem value)
]

{ #category : #api }
MiNavigationInspectionTab >> activateOnDoubleClick [

	navigation activateOnDoubleClick
]

{ #category : #api }
MiNavigationInspectionTab >> activateOnSingleClick [

	navigation activateOnSingleClick
]

{ #category : #'private - display' }
MiNavigationInspectionTab >> childrenFor: anEntity [

	^ self itemsFor: anEntity value
]

{ #category : #layout }
MiNavigationInspectionTab >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: navigation;
		  add: actionBar expand: false;
		  yourself
]

{ #category : #layout }
MiNavigationInspectionTab >> hidePropertiesPane [

	self layout remove: propertiesPane
]

{ #category : #'private - display' }
MiNavigationInspectionTab >> iconBlock [

	^ [ :el | el value mooseIcon ]
]

{ #category : #initialization }
MiNavigationInspectionTab >> initialize [

	super initialize.
	activationAction := SpActivationHolder new.
	self shouldShowPropertiesPane ifTrue: [ self showPropertiesPane ]
]

{ #category : #initialization }
MiNavigationInspectionTab >> initializeNavigationTreeTable [

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
		items: (self itemsFor: self inspectedObject);
		whenActivatedDo: [ self activate ]
]

{ #category : #initialization }
MiNavigationInspectionTab >> initializePresenters [

	self initializeNavigationTreeTable.

	actionBar := self newActionBar.
	actionBar add: (self newToggleButton
			 label: 'Properties';
			 help: 'Show properties panel - May be long to compute';
			 whenActivatedDo: [ self showPropertiesPane ];
			 whenDeactivatedDo: [ self hidePropertiesPane ];
			 yourself)
]

{ #category : #accessing }
MiNavigationInspectionTab >> inspectedObject [
	^ inspectedObject
]

{ #category : #accessing }
MiNavigationInspectionTab >> inspectedObject: anObject [
	inspectedObject := anObject
]

{ #category : #'private - display' }
MiNavigationInspectionTab >> itemsFor: anObject [

	^ anObject miMetaNavigationItems
]

{ #category : #'private - display' }
MiNavigationInspectionTab >> printEntry: anAssociation [

	^ String streamContents: [ :s |
		  s << anAssociation key.
		  (anAssociation value isBlock not and: [
			   anAssociation value mooseName ~= anAssociation key ]) ifFalse: [
			  ^ s contents ].
		  s << ': '.
		  s << anAssociation value mooseName ]
]

{ #category : #accessing }
MiNavigationInspectionTab >> selectedObject [

	^ navigation selection selectedItem value
]

{ #category : #'accessing - model' }
MiNavigationInspectionTab >> setModelBeforeInitialization: anInspectionModel [ 

	inspectedObject := anInspectionModel
]

{ #category : #testing }
MiNavigationInspectionTab >> shouldShowPropertiesPane [
	"This is legacy. Not removed because it may be used? If so, it should be a setting. Else, removed"

	^ shouldShowPropertiesPane ifNil: [
		  self class defaultShouldShowPropertiesPane ]
]

{ #category : #layout }
MiNavigationInspectionTab >> showPropertiesPane [

	propertiesPane ifNil: [
		propertiesPane := MiPropertyExtension on: self inspectedObject ].
	self layout add: propertiesPane
]
