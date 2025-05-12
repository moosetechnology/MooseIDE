"
A model for the CoUsageMap browser
"
Class {
	#name : #MiCoUsageMapModel,
	#superclass : #MiAbstractModel,
	#instVars : [
		'settingsWindow',
		'containerEntities',
		'selectedEntity',
		'methodAttributeCounter',
		'innerBoxes',
		'containerBoxes',
		'widthScale'
	],
	#category : #'MooseIDE-CoUsageMap-Model'
}

{ #category : #tagging }
MiCoUsageMapModel >> automaticColor [

	self changeTagsDuring: [ 
		self containerBoxes
			do: [:met | self automaticColorForContainerBox: met ].
	]
	
]

{ #category : #tagging }
MiCoUsageMapModel >> automaticColorForContainerBox: aMiContainer [
	"inner boxes are grouped by their tag (#groupsByTag)
	 If there are several groups, searches for the largest (ignoring the group of untagged)
	 then checks whether it size is >= threshold percent of all inner boxes.
	 If so, set the tag on aMiContainer"

	| groupsByTag tag |

	groupsByTag := aMiContainer innerBoxes groupedBy: [ :att | att tag ].
	groupsByTag ifEmpty: [ ^ self ].
	
	tag := self largestTag: groupsByTag in: aMiContainer.

	"note: tag could be nil here if we did not find a large enough group"
	self setTag: tag onInnerBox: aMiContainer.

]

{ #category : #tagging }
MiCoUsageMapModel >> changeTagsDuring: aBlockClosure [
	| lastTag |
	lastTag := self selectedTag.
	aBlockClosure value.
	self selectedTag: lastTag
]

{ #category : #'private - for tests' }
MiCoUsageMapModel >> closeSettings [
	"used only for closing settings opened in tests"
	settingsWindow ifNotNil: [ settingsWindow close ]
]

{ #category : #accessing }
MiCoUsageMapModel >> containerBoxNamed: aByteString [
	^ self containerBoxes detect: [ :contr | contr name = aByteString ]
]

{ #category : #accessing }
MiCoUsageMapModel >> containerBoxes [
	^containerBoxes
]

{ #category : #accessing }
MiCoUsageMapModel >> containerEntities [
	^ containerEntities
]

{ #category : #accessing }
MiCoUsageMapModel >> containerEntities: aCollection [
	containerEntities := aCollection
]

{ #category : #accessing }
MiCoUsageMapModel >> containerInnerCounter [

	^ methodAttributeCounter
]

{ #category : #accessing }
MiCoUsageMapModel >> containerInnerCounter: aMiCoMethodAttributeCounter [
	methodAttributeCounter := aMiCoMethodAttributeCounter
]

{ #category : #settings }
MiCoUsageMapModel >> defaultInnerSortBlock [
	^ [ :inner1 :inner2 :containr | inner1 name < inner2 name ].
]

{ #category : #settings }
MiCoUsageMapModel >> defaultSettings [
	^ MiCoUsageMapSettings
]

{ #category : #settings }
MiCoUsageMapModel >> defaultSortBlock [
	^ [ :container1 :container2 | 
		| size1 size2 |
		size1 := container1 innerBoxes size.
		size2 := container2 innerBoxes size.
		size1 = size2 
			ifTrue: [ container1 name < container2 name ]
			ifFalse: [ size1 > size2 ]
		 ].
]

{ #category : #settings }
MiCoUsageMapModel >> defaultTester [
	^ MiCoFromSettingsMethodAttributeTester new
]

{ #category : #accessing }
MiCoUsageMapModel >> entities [
	^containerEntities
]

{ #category : #actions }
MiCoUsageMapModel >> followEntity: aCollection [

	self containerEntities: aCollection.
	self initializeValues.
	browser runVisualization
]

{ #category : #accessing }
MiCoUsageMapModel >> getBoxFor: object [
	^(self getContainerBoxFor: object) ifNil: [ self getInnerBoxFor: object ]
]

{ #category : #accessing }
MiCoUsageMapModel >> getContainerBoxFor: object [
	^self containerBoxes
		detect: [ :box | box mooseEntity = object ]
		ifNone: [ nil ]
]

{ #category : #accessing }
MiCoUsageMapModel >> getInnerBoxFor: object [
	^self innerBoxes
		detect: [ :inner | inner mooseEntity = object ]
		ifNone: [ nil ]
]

{ #category : #accessing }
MiCoUsageMapModel >> getInnerBoxNamed: aByteString [
	^ self innerBoxes detect: [ :box | box name = aByteString ]
]

{ #category : #accessing }
MiCoUsageMapModel >> getOrCreateInnerBoxFor: object [

	^ (self getInnerBoxFor: object)
		ifNil: [ innerBoxes add: (self newInnerBoxFor: object) ]
]

{ #category : #initialization }
MiCoUsageMapModel >> initialize [
	super initialize.

	self containerInnerCounter: self defaultTester
]

{ #category : #initialization }
MiCoUsageMapModel >> initializeContainerBoxes [

	containerBoxes := self containerEntities 
		collect: [ :cont | self newContainerBoxFor: cont ]
		as: OrderedCollection.
]

{ #category : #initialization }
MiCoUsageMapModel >> initializeReferences [
	innerBoxes := OrderedCollection new.

	self containerInnerCounter settings: self settings.
	
	self containerBoxes do: [ :cont | 
		| bag |
		bag := Bag withAll: (self containerInnerCounter allAttributesFor: cont).
		bag doWithOccurrences: [ :innerEntity :count | | in |
			count > 0 ifTrue: [ 
				in := self getOrCreateInnerBoxFor: innerEntity.
				cont addInnerBox: in.
				in containerBox: cont numberOfUses: count.
			].
		].
	]
]

{ #category : #initialization }
MiCoUsageMapModel >> initializeScale [
	| allInnerUses range scaleType cls |

	allInnerUses := self containerBoxes flatCollect: [ :cont | 
		cont innerBoxes collect: [ :inner | inner numberOfUses ] ].
	cls := MiCoUsageMapSettings.
	range := cls innerBoxRange.
	scaleType := cls innerBoxScaleType.
	
	widthScale := (scaleType value: NSScale)
		range: {range first. range last}.
	allInnerUses ifEmpty: [ ^ self ].
	widthScale domain: {allInnerUses min. allInnerUses max}.
]

{ #category : #initialization }
MiCoUsageMapModel >> initializeValues [
	self
		initializeContainerBoxes;
		initializeReferences;
		initializeScale.
]

{ #category : #settings }
MiCoUsageMapModel >> innerBoxHeight [
	^self settings innerBoxHeight
]

{ #category : #settings }
MiCoUsageMapModel >> innerBoxSortBlockCompiled [
	^self settings innerBoxSortBlockCompiled
]

{ #category : #accessing }
MiCoUsageMapModel >> innerBoxes [
	^ innerBoxes
]

{ #category : #tagging }
MiCoUsageMapModel >> largestTag: groupsByTag in: containerBox [
	"inner boxes are grouped by their tag (#groupsByTag)
	 search the largest of these groups (ignoring the group of untagged)
	 then checks whether it size is >= threshold percent of all inner boxes.
	 If so, returns the tag of this group"

	| largestGroup tag |
	tag := nil.
	largestGroup := 0.

	groupsByTag keysAndValuesDo: [ :groupTag :group | 
		((groupTag isNotNil) and: [group size > largestGroup ])
		ifTrue: [
			tag := groupTag.
			largestGroup := group size ] ].

	^(largestGroup / containerBox innerBoxes size) >= self threshold 
		ifTrue: [ tag ]
		ifFalse: [ nil ]
]

{ #category : #accessing }
MiCoUsageMapModel >> miSelectedItem [
	^selectedEntity
]

{ #category : #'instance creation' }
MiCoUsageMapModel >> newContainerBoxFor: anObject [
	"| tags |
	tags := anObject allTagAssociations collect: [ :asso | asso tag ].
	tags := tags
		ifEmpty: [ nil ]
		ifNotEmpty: [ tags anyOne ]."
	^ MiCoContainerBox new
		mooseEntity: anObject;
		yourself
]

{ #category : #'instance creation' }
MiCoUsageMapModel >> newInnerBoxFor: anObject [
	| tags |
	tags := anObject allTagAssociations collect: [ :asso | asso tag ].
	tags := tags
		ifEmpty: [ nil ]
		ifNotEmpty: [ tags anyOne ].
	^ MiCoInnerBox new
		mooseEntity: anObject;
		yourself
]

{ #category : #settings }
MiCoUsageMapModel >> openSettings [
	"For now, we handle settings here:
	 - create the window 
	 - subscribe to be informed when any window is closed closed
	 - if this is the setting window that is closed
	    - unsubscribe to ALL announcements
	    - update the visualization"

	| settingBrowser |
	settingBrowser := SettingBrowser new.
	settingBrowser changePackageSet: (OrderedCollection with: (self packageOrganizer packageNamed: MiCoUsageMapSettings package name)).
	settingsWindow := settingBrowser open.
	settingsWindow position: self currentWorld extent - settingsWindow extent // 2.
	settingBrowser expandAll.

	self currentWorld announcer
		when: WindowClosed
		do: [ :annoucement |
			annoucement window = settingsWindow ifTrue: [
				self currentWorld announcer unsubscribe: self.
				browser runVisualization ] ]
		for: self
]

{ #category : #settings }
MiCoUsageMapModel >> outerBoxSortBlockCompiled [
	^self settings outerBoxSortBlockCompiled
]

{ #category : #events }
MiCoUsageMapModel >> quickTaggingOn: entity [ 

	self selectedTag
	ifNil: [ ^ self ]
	ifNotNil: [ :tag | self setTag: tag onInnerBox: entity ]

]

{ #category : #tagging }
MiCoUsageMapModel >> removeTagOn: aMooseEntity [
	aMooseEntity allTags
		detect: [ :aTag | aTag isHidden not ]
		ifOne: [ :aTag | aTag removeReference: aMooseEntity ]
		ifNone: [ "nothing" ]
]

{ #category : #accessing }
MiCoUsageMapModel >> selectedEntity [
	^selectedEntity
]

{ #category : #accessing }
MiCoUsageMapModel >> selectedEntity: aMooseEntity [

	selectedEntity := aMooseEntity
]

{ #category : #tagging }
MiCoUsageMapModel >> setTag: aTag onInnerBox: aBox [

	self flag: #FIXME.
	"- #tagEntity:with: already calls #selectedTag:
	 - #tagEntity:with: calls #getBoxFor: to find back aBox"

	self selectedTag: aTag.
	self tagEntity: aBox mooseEntity with: aTag
]

{ #category : #settings }
MiCoUsageMapModel >> settings [
	self flag: #FIXME.
	"settings should not be handled by a an other class (with only class side methods"

	^MiCoUsageMapSettings
]

{ #category : #tagging }
MiCoUsageMapModel >> tagEntity: aMooseEntity with: aTag [
	"entites can have only one tag in this tool"

	self removeTagOn: aMooseEntity.

	super tagEntity: aMooseEntity with: aTag.

	browser updateBoxColor: (self getBoxFor: aMooseEntity) fromTags: aMooseEntity allTags.
	self selectedTag: aTag
]

{ #category : #settings }
MiCoUsageMapModel >> threshold [

	^self settings threshold75PercentGroup/100.0
]

{ #category : #accessing }
MiCoUsageMapModel >> widthScale [
	^ widthScale
]
