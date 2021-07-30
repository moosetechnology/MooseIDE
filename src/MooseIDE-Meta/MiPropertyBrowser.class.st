"
Shows properties of a MooseObject.

- Follow: Receives MooseObjects
- Highlight: Nothing to do.
- Propagate: <TODO>
"
Class {
	#name : #MiPropertyBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'properties'
	],
	#category : #'MooseIDE-Meta-PropertyBrowser'
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
	<miBrowsers>
	(aBuilder item: #PropertyBrowser)
		parent: (self metaBrowsersMenuLabel);
		label: (self title);
		icon: (self iconNamed: #mooseProperties);
		order: 3;
		help: (self helpMessage);
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
	self model: anEntity.
	properties
		items:
			(anEntity mooseDescription allPrimitiveProperties
				sorted: #name ascending).
	self updateWindowTitleWith: anEntity name
]

{ #category : #initialization }
MiPropertyBrowser >> initializePresenters [
	super initializePresenters.
	self
		flag:
			'This currently duplicated code from Midas-NewTools. We have to thing about a good way to integrate all browser inside the inspector'.
	properties := self newTable
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
						do: [ :e | e description ] ]);
		beResizable;
		contextMenu: [ self rootCommandsGroup asMenuPresenter ]
]

{ #category : #accessing }
MiPropertyBrowser >> miSelectedItem [
	self
		flag:
			'This is probably wrong: we allow propagation of a primitive value (number, string, boolean), 
				which is not a mooseObject and should probably not be propagated.
				However, this allows to reproduce errors occuring while getting the property.'.
	^ properties selection selectedItem
		ifNotNil: [ :item | self model mmGetProperty: item ]
]

{ #category : #initialization }
MiPropertyBrowser >> updateWindowTitleWith: aName [
	self
		withWindowDo:
			[ :window | window title: self class title , ': Properties of ' , aName ]
]
