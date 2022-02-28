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
		'settingsToggle',
		'tagCreateForm'
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

{ #category : #adding }
MiHierarchicalMapBrowser >> addDynamicTags: aCollection [

	aCollection do: [ :dt | self model addDynamicTag: dt ].
	settings refreshTagList
]

{ #category : #initialization }
MiHierarchicalMapBrowser >> addmenuButtonToCanvas [

	self canvas addShape: settingsToggle.
	settingsToggle setAsFixed.
	settingsToggle translateTopLeftTo: 5 @ 0.
]

{ #category : #initialization }
MiHierarchicalMapBrowser >> browserClosed [

	super browserClosed.
	application unregisterConsumer: self
]

{ #category : #actions }
MiHierarchicalMapBrowser >> canFollowEntity: anEntity [

	^ anEntity isMooseObject
]

{ #category : #testing }
MiHierarchicalMapBrowser >> canReceiveEntity: anEntity [

	^ anEntity isMooseObject
]

{ #category : #initialization }
MiHierarchicalMapBrowser >> canvas [

	^ visualization canvas
]

{ #category : #initialization }
MiHierarchicalMapBrowser >> closeTagCreationForm [

	self layout replace: tagCreateForm with: settings
]

{ #category : #brokerage }
MiHierarchicalMapBrowser >> consume: aTag [

	tagCreateForm setTags
]

{ #category : #actions }
MiHierarchicalMapBrowser >> followEntity: anEntity [

	model entities: anEntity asMooseGroup.
	self showMenu
]

{ #category : #actions }
MiHierarchicalMapBrowser >> hideMenu [

	settingsToggle text: '> Show settings'.
	settingsToggle translateTopLeftTo: 5 @ 0.
	self layout remove: settings
]

{ #category : #initialization }
MiHierarchicalMapBrowser >> initialize [

	super initialize.
	application registerConsumer: self for: MiDynamicTag
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
	tagCreateForm := MiDynamicTagCreationForm owner: self.
	self initializeLayout
]

{ #category : #accessing }
MiHierarchicalMapBrowser >> miSelectedItem [

	^ model entities mooseInterestingEntity
]

{ #category : #initialization }
MiHierarchicalMapBrowser >> openTagCreationForm [

	tagCreateForm setTags.
	self layout replace: settings with: tagCreateForm.
	self update
]

{ #category : #brokerage }
MiHierarchicalMapBrowser >> remove: aTag [

	tagCreateForm removeTag: aTag
]

{ #category : #actions }
MiHierarchicalMapBrowser >> showMenu [

	settingsToggle text: '< Hide settings'.
	settingsToggle translateTopLeftTo: 5 @ 0.
	self layout
		removeAll;
		add: settings width: self class windowSize x / 3;
		add: visualization
]

{ #category : #actions }
MiHierarchicalMapBrowser >> toggleMenu [

	(self layout presenters includes: settings)
		ifTrue: [ self hideMenu ]
		ifFalse: [ self showMenu ]
]

{ #category : #initialization }
MiHierarchicalMapBrowser >> visualization [

	^ visualization
]
