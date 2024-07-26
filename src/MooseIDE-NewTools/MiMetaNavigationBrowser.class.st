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
		'activateOnSingleClick'
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

	^ SpBoxLayout newVertical
		  add: #navigation;
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

	navigation := self newTable.
	items := self filterEmptyValues: (self itemsFor: self model).
	navigation
		addColumn: (SpImageTableColumn new
				 beNotExpandable;
				 evaluated: self iconBlock;
				 yourself);
		addColumn: (SpStringTableColumn new
				 title: 'Entities';
				 evaluated: [ :el | el key ];
				 beSortable;
				 yourself).
	navigation
		contextMenu: [ self rootCommandsGroup asMenuPresenter ];
		items: items.
	navigation whenActivatedDo: [ :selection |
		self inspectorObjectContextPresenter owner
			changeSelection: selection selectedItem value
			from: self inspectorObjectContextPresenter ]
]

{ #category : #initialization }
MiMetaNavigationBrowser >> inspectorObjectContextPresenter [

	^ self owner owner owner owner
]

{ #category : #initialization }
MiMetaNavigationBrowser >> itemsFor: anEntity [

	^ anEntity mooseDescription allComplexProperties
		  collect: [ :property | 
			  property name
			  -> (anEntity propertyNamed: property name ifAbsent: [ nil ]) ]
		  thenReject: [ :assoc | 
			  assoc value isNil or: [ 
				  assoc value isCollection and: [ assoc value isEmpty ] ] ]
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
