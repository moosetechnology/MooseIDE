"
Shows properties of a MooseObject.

- Follow: 
Receives MooseObjects

- Highlight:
Nothing to do.

- Propagate:
<TODO>
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
		label: self title;
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
	^ 'Properties'
]

{ #category : #initialization }
MiPropertyBrowser >> accept: anObject [
	^ anObject isMooseObject
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
