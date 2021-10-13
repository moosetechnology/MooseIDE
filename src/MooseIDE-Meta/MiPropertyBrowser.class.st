"
Shows properties of a MooseObject.

- Follow: Receives MooseObjects
- Highlight: Nothing to do.
- Propagate: The MooseObject it shows.
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
		action: [ self open ]
]

{ #category : #specs }
MiPropertyBrowser class >> open [
	<script>
	^ super open
]

{ #category : #initialization }
MiPropertyBrowser class >> title [
	^ 'Properties'
]

{ #category : #initialization }
MiPropertyBrowser >> canReceiveEntity: anObject [
	^ anObject isMooseObject
]

{ #category : #actions }
MiPropertyBrowser >> followEntity: anEntity [

	self model: anEntity.
	properties items:
		(anEntity mooseDescription allPrimitiveProperties sorted:
			 #name ascending).
	self updateWindowTitleWith: anEntity name.
	self updateToolbar
]

{ #category : #initialization }
MiPropertyBrowser >> initializePresenters [

	super initializePresenters.

	properties := self newTable
		              addColumn: (SpStringTableColumn
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
		              contextMenu: [ 
			              (self rootCommandsGroup commandOrGroupNamed:
					               'Actions') beRoot asMenuPresenter ]
]

{ #category : #accessing }
MiPropertyBrowser >> miSelectedItem [

	^ self model
]

{ #category : #initialization }
MiPropertyBrowser >> updateWindowTitleWith: aName [
	self
		withWindowDo:
			[ :window | window title: self class title , ': Properties of ' , aName ]
]
