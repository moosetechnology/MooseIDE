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
		'activationBlock'
	],
	#category : #Midas
}

{ #category : #specs }
MiNavigationBrowser class >> buildCommandsGroupWith: presenter forRoot: aCmCommandsGroup [
	aCmCommandsGroup
		beDisplayedAsGroup;
		register: (StInspectorInspectSelectedCommand forSpecContext: presenter)
]

{ #category : #specs }
MiNavigationBrowser class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #navigation
]

{ #category : #accessing }
MiNavigationBrowser >> connectPresenters [
	navigation whenSelectionChangedDo: [ :selection | activationBlock cull: self ]
]

{ #category : #initialization }
MiNavigationBrowser >> defineOutputPorts [
	^ { 
	SpSelectionPort newDelegate: [ navigation ].
	SpActivationPort newDelegate: [ navigation ] }
]

{ #category : #initialization }
MiNavigationBrowser >> initializePresenters [
	navigation := self newList.

	navigation
		contextMenu: [ self rootCommandsGroup asMenuPresenter ];
		items: (self itemsFor: self model);
		display: [ :item | item key ];
		icons: [ :item | item value mooseIcon ];
		sortingBlock: [ :a :b | a key asString < b key asString ]
]

{ #category : #initialization }
MiNavigationBrowser >> itemsFor: anEntity [
	^ (anEntity mooseDescription allComplexProperties
		collect: [ :property | property name -> (anEntity propertyNamed: property name) ]
		thenReject: [ :assoc | assoc value isNil or: [ assoc value isCollection and: [ assoc value isEmpty ] ] ]) 
]

{ #category : #accessing }
MiNavigationBrowser >> model [
	^ model
]

{ #category : #accessing }
MiNavigationBrowser >> model: anObject [
	model := anObject
]

{ #category : #accessing }
MiNavigationBrowser >> selectedItem [
	^ navigation selection selectedItem value
]

{ #category : #initialization }
MiNavigationBrowser >> selectedObject [ 
	^ navigation selection selectedItem value
]

{ #category : #accessing }
MiNavigationBrowser >> setModelBeforeInitialization: anInspectionModel [ 

	model := anInspectionModel
]

{ #category : #accessing }
MiNavigationBrowser >> whenActivatedDo: aBlock [

	activationBlock := aBlock
]
