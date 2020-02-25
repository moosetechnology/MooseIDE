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
	fameExtension:		<Object>


    Implementation Points
"
Class {
	#name : #MiPropertyBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'propertyExtension'
	],
	#category : #'Midas-PropertyBrowser'
}

{ #category : #specs }
MiPropertyBrowser class >> defaultSpec [
	^ super defaultSpec
		add: #propertyExtension;
		yourself
]

{ #category : #specs }
MiPropertyBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: #PropertyBrowser)
		parent: self toolbarMetaName;
		label: 'Properties browser';
		icon: (self iconNamed: #mooseProperties);
		order: 3.0;
		action: [ self runMe ]
]

{ #category : #specs }
MiPropertyBrowser class >> runMe [
	<script>
	self new openWithSpec
]

{ #category : #initialization }
MiPropertyBrowser >> accept: anObject [
	^ self isNotFreeze and: [ anObject isMooseEntity ] 
]

{ #category : #initialization }
MiPropertyBrowser >> initializePresenters [
	super initializePresenters.
	propertyExtension := MiPropertyExtension on: MooseModel new
]

{ #category : #initialization }
MiPropertyBrowser >> selectEntity: anEntity [
	(self accept: anEntity)
		ifFalse: [ ^ self ].
	propertyExtension model: anEntity.
]

{ #category : #initialization }
MiPropertyBrowser >> title [
	^ 'Properties Browser'
]
