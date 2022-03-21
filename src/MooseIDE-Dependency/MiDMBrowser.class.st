Class {
	#name : #MiDMBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'visualization',
		'layoutWithMenu',
		'layoutWithoutMenu',
		'settings',
		'tagCreateForm'
	],
	#category : #'MooseIDE-Dependency-DistributionMap'
}

{ #category : #accessing }
MiDMBrowser class >> mapClass [

	^ MiDM
]

{ #category : #'world menu' }
MiDMBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
	^(aBuilder item: #DMBrowser)
		parent: self midasBrowserMenuLabel;
		label: self title;
		help: self helpMessage;
		order: 5;
		action: [ self open ] ;
		yourself
]

{ #category : #'instance creation' }
MiDMBrowser class >> newModel [

	^ MiDistributionMapModel new
]

{ #category : #accessing }
MiDMBrowser class >> open [
	<script>
	super open
]

{ #category : #accessing }
MiDMBrowser class >> title [

	^ 'Distribution map'
]

{ #category : #accessing }
MiDMBrowser class >> windowSize [

	^ 850 @ 520
]

{ #category : #adding }
MiDMBrowser >> addDynamicTags: aCollection [

	aCollection do: [ :dt | self model addDynamicTag: dt ].
	settings refreshTagList
]

{ #category : #initialization }
MiDMBrowser >> browserClosed [

	super browserClosed.
	application unregisterConsumer: self.
	application unregisterConsumer: settings
]

{ #category : #actions }
MiDMBrowser >> canFollowEntity: anEntity [

	^ anEntity isMooseObject
]

{ #category : #testing }
MiDMBrowser >> canReceiveEntity: anEntity [

	^ anEntity isMooseObject
]

{ #category : #initialization }
MiDMBrowser >> canvas [

	^ visualization canvas
]

{ #category : #initialization }
MiDMBrowser >> closeTagCreationForm [

	self layout replace: tagCreateForm with: settings
]

{ #category : #brokerage }
MiDMBrowser >> consume: aTag [

	tagCreateForm setTags
]

{ #category : #actions }
MiDMBrowser >> followEntity: anEntity [

	model entities: anEntity asMooseGroup.
	self showMenu
]

{ #category : #testing }
MiDMBrowser >> hasSettings [

	^ true
]

{ #category : #actions }
MiDMBrowser >> hideMenu [

	self layout remove: settings.
	self update
]

{ #category : #initialization }
MiDMBrowser >> initialize [

	super initialize.
	application registerConsumer: self for: MiDynamicTag.
	application registerConsumer: settings for: FQAbstractQuery
]

{ #category : #initialization }
MiDMBrowser >> initializeLayout [

	self layout: (SpBoxLayout newLeftToRight
			 spacing: 3;
			 add: visualization;
			 yourself)
]

{ #category : #initialization }
MiDMBrowser >> initializePresenters [

	visualization := self class mapClass owner: self.
	settings := MiDistributionMapSettings owner: self.
	tagCreateForm := MiDynamicTagSelectionForm owner: self.
	self initializeLayout
]

{ #category : #accessing }
MiDMBrowser >> miSelectedItem [

	^ model entities mooseInterestingEntity
]

{ #category : #initialization }
MiDMBrowser >> openTagCreationForm [

	tagCreateForm setTags.
	self layout replace: settings with: tagCreateForm.
	self update
]

{ #category : #brokerage }
MiDMBrowser >> remove: aTag [

	tagCreateForm removeTag: aTag
]

{ #category : #accessing }
MiDMBrowser >> settings [

	self showMenu
]

{ #category : #accessing }
MiDMBrowser >> settingsPresenter [

	^ settings
]

{ #category : #actions }
MiDMBrowser >> showMenu [

	self layout
		removeAll;
		add: settings width: self class windowSize x / 3;
		add: visualization.

	self update
]

{ #category : #actions }
MiDMBrowser >> toggleMenu [

	(self layout presenters includes: settings)
		ifTrue: [ self hideMenu ]
		ifFalse: [ self showMenu ]
]

{ #category : #initialization }
MiDMBrowser >> visualization [

	^ visualization
]
