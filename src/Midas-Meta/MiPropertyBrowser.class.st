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
		'properties'
	],
	#category : #'Midas-Meta-PropertyBrowser'
}

{ #category : #specs }
MiPropertyBrowser class >> defaultSpec [
	^ super defaultSpec
		add: #properties;
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
	^ super runMe
]

{ #category : #initialization }
MiPropertyBrowser class >> title [
	^ 'Properties Browser'
]

{ #category : #initialization }
MiPropertyBrowser >> accept: anObject [
	^ anObject isMooseEntity
]

{ #category : #initialization }
MiPropertyBrowser >> followAction [
	(self accept: toSelect)
		ifFalse: [ ^ self ].
	self forEntity: toSelect
]

{ #category : #initialization }
MiPropertyBrowser >> forEntity: anEntity [
	properties items: (anEntity mooseDescription allPrimitiveProperties sorted: #name ascending).
]

{ #category : #initialization }
MiPropertyBrowser >> initializePresenters [
	super initializePresenters.
	self
		flag:
			'This currently duplicated code from Midas-NewTools. We have to thing about a good way to integrate all browser inside the inspector'.
	properties := self newTable.
	properties
		addColumn:
			(SpStringTableColumn
				title: 'Properties'
				evaluated: [ :item | item name ]) yourself;
		addColumn:
			(SpStringTableColumn
				title: 'Value'
				evaluated: [ :item | 
					[ self model mmGetProperty: item ]
						on: Error
						do: [ 'error' ] ]);
		items:
			(self model mooseDescription allPrimitiveProperties
				sorted: #name ascending);
		beResizable
]
