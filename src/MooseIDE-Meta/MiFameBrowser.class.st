"
** Expert user **
Shows the metadescription of a MooseObject.

- Accepted entities: a MooseObject.
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
	^ self buildMenuItemIn: aBuilder
]

{ #category : #'world menu' }
MiFameBrowser class >> menuIconName [

	^ #mooseFame
]

{ #category : #'world menu' }
MiFameBrowser class >> menuItem [

	^ #Fame
]

{ #category : #'world menu' }
MiFameBrowser class >> menuParent [

	^ self oldMetaBrowsersMenuRoot
]

{ #category : #'world menu' }
MiFameBrowser class >> menuPriority [

	^ 4
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

{ #category : #testing }
MiFameBrowser >> canTagEntities [ 

	^false
]

{ #category : #actions }
MiFameBrowser >> followEntity: anEntity [

	specModel := anEntity.
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

	^ specModel
]

{ #category : #actions }
MiFameBrowser >> updateWindowTitleWith: aName [
	self
		withWindowDo:
			[ :window | window title: self class title , ': Moose description of ' , aName ]
]
