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
		'tagCreateForm'
	],
	#category : #'MooseIDE-Dependency-HierarchicalMap'
}

{ #category : #accessing }
MiHierarchicalMapBrowser class >> mapClass [

	^ MiHierarchicalMap
]

{ #category : #'world menu' }
MiHierarchicalMapBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
	^(aBuilder item: #HierarchicalMapBrowser)
		parent: self midasBrowserMenuLabel;
		label: self title;
		help: self helpMessage;
		order: 5;
		action: [ self open ] ;
		yourself
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
MiHierarchicalMapBrowser >> browserClosed [

	super browserClosed.
	application unregisterConsumer: self.
	application unregisterConsumer: settings
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

	settings setTags
]

{ #category : #actions }
MiHierarchicalMapBrowser >> followEntity: anEntity [

	model entities: anEntity asMooseGroup.
	settings updateSettings.
	self showMenu
]

{ #category : #testing }
MiHierarchicalMapBrowser >> hasSettings [

	^ true
]

{ #category : #actions }
MiHierarchicalMapBrowser >> hideMenu [

	self layout child: visualization
]

{ #category : #initialization }
MiHierarchicalMapBrowser >> initialize [

	super initialize.
	application registerConsumer: self for: FamixTag.
	application registerConsumer: settings for: FQAbstractQuery
]

{ #category : #initialization }
MiHierarchicalMapBrowser >> initializeLayout [

	self layout: (SpScrollableLayout with: visualization)
]

{ #category : #initialization }
MiHierarchicalMapBrowser >> initializePresenters [

	visualization := self class mapClass owner: self.
	settings := MiHierarchicalMapSettings owner: self.
	settings setTags.
	tagCreateForm := MiDynamicTagSelectionForm owner: self.
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

{ #category : #accessing }
MiHierarchicalMapBrowser >> settings [

	self showMenu
]

{ #category : #accessing }
MiHierarchicalMapBrowser >> settingsPresenter [

	^ settings
]

{ #category : #actions }
MiHierarchicalMapBrowser >> showMenu [

	self layout child: settings
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
