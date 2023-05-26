"
Shows properties of a MooseObject.

- Accepted entities: any MooseObject
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

{ #category : #layout }
MiPropertyBrowser class >> defaultLayout [

	^ super defaultLayout
		  add: #properties;
		  yourself
]

{ #category : #'world menu' }
MiPropertyBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ self buildMenuItemIn: aBuilder
]

{ #category : #'world menu' }
MiPropertyBrowser class >> menuIconName [

	^ #mooseProperties
]

{ #category : #'world menu' }
MiPropertyBrowser class >> menuItem [

	^ #PropertyBrowser
]

{ #category : #'world menu' }
MiPropertyBrowser class >> menuParent [

	^ self oldMetaBrowsersMenuRoot
]

{ #category : #'world menu' }
MiPropertyBrowser class >> menuPriority [

	^ 3
]

{ #category : #'instance creation' }
MiPropertyBrowser class >> open [

	<script>
	^ super open
]

{ #category : #specs }
MiPropertyBrowser class >> title [

	^ 'Properties'
]

{ #category : #initialization }
MiPropertyBrowser >> canFollowEntity: anObject [
	^ anObject isMooseObject
]

{ #category : #testing }
MiPropertyBrowser >> canTagEntities [ 
	self flag: 'Remove browser ? (issue #810)'.
	^false
]

{ #category : #actions }
MiPropertyBrowser >> followEntity: anEntity [

	self model: anEntity.
	properties items:
		(anEntity mooseDescription allPrimitiveProperties sorted:
			 #name ascending).
	self updateWindowTitleWith: anEntity name
]

{ #category : #initialization }
MiPropertyBrowser >> initializePresenters [

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
