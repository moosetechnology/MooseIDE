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
	#name : #MiNavigationBrowser,
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
MiNavigationBrowser class >> buildCommandsGroupWith: presenter forRoot: aCmCommandsGroup [
	aCmCommandsGroup
		beDisplayedAsGroup;
		register: (StInspectorInspectSelectedCommand forSpecContext: presenter)
]

{ #category : #layout }
MiNavigationBrowser class >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: #navigation;
		  yourself
]

{ #category : #initialization }
MiNavigationBrowser >> activateOnSingleClick [
	navigation activateOnSingleClick
]

{ #category : #accessing }
MiNavigationBrowser >> activateOnSingleClick: anObject [

	activateOnSingleClick := anObject
]

{ #category : #action }
MiNavigationBrowser >> filterEmptyValues: entities [

	^ entities select: [ :each | 
		  each value isCollection
			  ifTrue: [ each value isNotEmpty ]
			  ifFalse: [ true ] ]
]

{ #category : #initialization }
MiNavigationBrowser >> hasOutputActivationPort [

	^ true
]

{ #category : #initialization }
MiNavigationBrowser >> iconBlock [

	^ [ :el | el value mooseIcon ]
]

{ #category : #initialization }
MiNavigationBrowser >> initializePresenters [

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
MiNavigationBrowser >> inspectorObjectContextPresenter [

	^ self owner owner owner owner
]

{ #category : #initialization }
MiNavigationBrowser >> itemsFor: anEntity [

	^ anEntity mooseDescription allComplexProperties
		  collect: [ :property | 
			  property name
			  -> (anEntity propertyNamed: property name ifAbsent: [ nil ]) ]
		  thenReject: [ :assoc | 
			  assoc value isNil or: [ 
				  assoc value isCollection and: [ assoc value isEmpty ] ] ]
]

{ #category : #accessing }
MiNavigationBrowser >> model [
	^ model
]

{ #category : #accessing }
MiNavigationBrowser >> model: anObject [
	model := anObject
]

{ #category : #initialization }
MiNavigationBrowser >> outputActivationPort [
	^ (SpActivationPort newPresenter: self)
		yourself
]

{ #category : #accessing }
MiNavigationBrowser >> selectedItem [
	
	^ navigation selection selectedItem value
]

{ #category : #initialization }
MiNavigationBrowser >> selectedObject [
	^ navigation selection selectedItem value
]

{ #category : #'accessing - model' }
MiNavigationBrowser >> setModelBeforeInitialization: anInspectionModel [ 

	model := anInspectionModel
]

{ #category : #initialization }
MiNavigationBrowser >> whenActivatedDo: aBlock [
	activationBlock := aBlock
]
