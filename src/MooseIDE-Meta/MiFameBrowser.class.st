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

{ #category : #layout }
MiFameBrowser class >> defaultLayout [
	^ super defaultLayout
		add: #fameDescription;
		yourself
]

{ #category : #'world menu' }
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

{ #category : #'instance creation' }
MiFameBrowser class >> open [
	<script>
	^ super open
]

{ #category : #specs }
MiFameBrowser class >> title [
	^ 'Fame'
]

{ #category : #testing }
MiFameBrowser >> canFollowEntity: anObject [

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

	fameDescription := self newTable.
	fameDescription
		items: (self model mooseDescription allComplexProperties sorted:
					 #name ascending);
		addColumn:
			(SpStringTableColumn title: 'Name' evaluated: [ :item | item name ])
				yourself;
		addColumn: (SpStringTableColumn
				 title: 'Type'
				 evaluated: [ :item | item type name ]) yourself;
		addColumn:
			(SpStringTableColumn title: 'Opposite' evaluated: [ :item | 
					 item opposite
						 ifNil: [ '' ]
						 ifNotNil: [ :opposite | opposite name ] ]) yourself;
		addColumn: (SpStringTableColumn
				 title: 'Derived?'
				 evaluated: [ :item | item isDerived ]) yourself;
		addColumn: (SpStringTableColumn
				 title: 'Container?'
				 evaluated: [ :item | item isContainer ]) yourself;
		addColumn: (SpStringTableColumn
				 title: 'IsTarget?'
				 evaluated: [ :item | item isTarget ]) yourself;
		addColumn: (SpStringTableColumn
				 title: 'IsSource?'
				 evaluated: [ :item | item isSource ]) yourself;
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
