"
I am a browser that display a hieracical map.
"
Class {
	#name : #MiHierarchicalMapBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'visualization',
		'layoutWithMenu',
		'layoutWithoutMenu',
		'settings',
		'settingsToggle'
	],
	#category : #'MooseIDE-Dependency-HierarchicalMap'
}

{ #category : #accessing }
MiHierarchicalMapBrowser class >> mapClass [

	^ MiHierarchicalMap
]

{ #category : #'instance creation' }
MiHierarchicalMapBrowser class >> newModel [

	^ MiHierarchicalMapModel new
]

{ #category : #accessing }
MiHierarchicalMapBrowser class >> open [
	<script>
	super open
]

{ #category : #accessing }
MiHierarchicalMapBrowser class >> title [

	^ 'Hierarchical map'
]

{ #category : #accessing }
MiHierarchicalMapBrowser class >> windowSize [

	^ 850 @ 520
]

{ #category : #initialization }
MiHierarchicalMapBrowser >> addmenuButtonToCanvas [

	self canvas addShape: settingsToggle.
	settingsToggle setAsFixed.
	settingsToggle translateTopLeftTo: 5 @ 0.
]

{ #category : #testing }
MiHierarchicalMapBrowser >> canReceiveEntity: anEntity [

	^ anEntity isMooseObject
]

{ #category : #initialization }
MiHierarchicalMapBrowser >> canvas [

	^ visualization canvas
]

{ #category : #actions }
MiHierarchicalMapBrowser >> followEntity: anEntity [

	model entities: anEntity asMooseGroup.
	self showMenu
]

{ #category : #'as yet unclassified' }
MiHierarchicalMapBrowser >> hideMenu [

	settingsToggle text: '> Show settings'.
	settingsToggle translateTopLeftTo: 5 @ 0.
	self layout remove: settings
]

{ #category : #initialization }
MiHierarchicalMapBrowser >> initializeLayout [

	self layout: (SpBoxLayout newLeftToRight
			 spacing: 3;
			 add: visualization;
			 yourself)
]

{ #category : #initialization }
MiHierarchicalMapBrowser >> initializePresenters [

	visualization := self class mapClass owner: self.
	settings := MiHierarchicalMapSettings owner: self.
	settingsToggle := RSLabel new when: RSMouseClick do: [ self toggleMenu ].
	self initializeLayout
]

{ #category : #accessing }
MiHierarchicalMapBrowser >> miSelectedItem [

	^ model entities mooseInterestingEntity
]

{ #category : #'as yet unclassified' }
MiHierarchicalMapBrowser >> showMenu [

	settingsToggle text: '< Hide settings'.
	settingsToggle translateTopLeftTo: 5 @ 0.
	self layout
		removeAll;
		add: settings width: self class windowSize x / 3;
		add: visualization
]

{ #category : #'as yet unclassified' }
MiHierarchicalMapBrowser >> toggleMenu [

	(self layout presenters includes: settings)
		ifTrue: [ self hideMenu ]
		ifFalse: [ self showMenu ]
]

{ #category : #initialization }
MiHierarchicalMapBrowser >> visualization [

	^ visualization
]