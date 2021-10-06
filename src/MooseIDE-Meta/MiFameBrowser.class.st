"
** Expert user **
Shows the metadescription of a MooseObject.

- Follow: Recevies a MooseObject.
- Highlight: Nothing to do.
- Propagate: <TODO>
"
Class {
	#name : #MiFameBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'fameDescription'
	],
	#category : #'MooseIDE-Meta-FameBrowser'
}

{ #category : #specs }
MiFameBrowser class >> defaultSpec [
	^ super defaultSpec
		add: #fameDescription;
		yourself
]

{ #category : #specs }
MiFameBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
	(aBuilder item: #Fame)
		parent: (self metaBrowsersMenuLabel);
		label: (self title);
		icon: (self iconNamed: #mooseFame);
		order: 4;
		help: (self helpMessage);
		action: [ self open ]
]

{ #category : #specs }
MiFameBrowser class >> open [
	<script>
	^ super open
]

{ #category : #initialization }
MiFameBrowser class >> title [
	^ 'Fame'
]

{ #category : #testing }
MiFameBrowser >> canReceiveEntity: anObject [

	^ anObject isMooseEntity
]

{ #category : #actions }
MiFameBrowser >> followEntity: anEntity [

	model := anEntity.
	fameDescription items: anEntity mooseDescription allComplexProperties.
	self updateWindowTitleWith: anEntity name
]

{ #category : #initialization }
MiFameBrowser >> initializePresenters [
	super initializePresenters.
	self flag: 'This currently duplicated code from Midas-NewTools. We have to thing about a good way to integrate all browser inside the inspector'.
	fameDescription := self newTable.
	fameDescription
		items: (self model mooseDescription allComplexProperties sorted: #name ascending);
		addColumn: (SpStringTableColumn title: 'Name' evaluated: [ :item | item name ]) yourself;
		addColumn: (SpStringTableColumn title: 'Type' evaluated: [ :item | item type name ]) yourself;
		addColumn: (SpStringTableColumn title: 'Opposite' evaluated: [ :item | item opposite ifNil: [ '' ] ifNotNil: [ :opposite | opposite name ] ]) yourself;
		addColumn: (SpStringTableColumn title: 'Derived?' evaluated: [ :item | item isDerived ]) yourself;
		addColumn: (SpStringTableColumn title: 'Container?' evaluated: [ :item | item isContainer ]) yourself;
		addColumn: (SpStringTableColumn title: 'IsTarget?' evaluated: [ :item | item isTarget ]) yourself;
		addColumn: (SpStringTableColumn title: 'IsSource?' evaluated: [ :item | item isSource ]) yourself;
		beResizable
]

{ #category : #accessing }
MiFameBrowser >> miSelectedItem [

	^ model
]

{ #category : #actions }
MiFameBrowser >> updateWindowTitleWith: aName [
	self
		withWindowDo:
			[ :window | window title: self class title , ': Moose description of ' , aName ]
]
