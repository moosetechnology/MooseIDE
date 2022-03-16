"
I create a menu for each element and the main canvas in MiCoUsageMapBuilder.
Mark means, put a tag into an attribute or method.
My resposability is automatize the marking process. Check automaticColor, is related to MiCoMarkStrategy
"
Class {
	#name : #MiCoMarkManager,
	#superclass : #RSInteraction,
	#instVars : [
		'coUsageMap',
		'menuInteraction',
		'strategies',
		'lastTagSelected'
	],
	#category : #'MooseIDE-CoUsageMap-Roassal3'
}

{ #category : #public }
MiCoMarkManager >> automaticColor [
	self changeTagsDuring: [ 
		self coUsageMap miMethods 
			do:[:met | self automaticColorForMethod: met ].
	]
	
]

{ #category : #public }
MiCoMarkManager >> automaticColorForMethod: aMiCoMethod [
	| groupsByTag conflictTag |
	conflictTag := self conflictTag.
	groupsByTag := aMiCoMethod usedAttributes 
		groupedBy: [ :att | att tag ].
	groupsByTag ifEmpty: [
		 "nothing to compare" ^ self ].
	self strategies do: [ :strat |
		strat
			method: aMiCoMethod;
			groupsByTag: groupsByTag.
		strat computeTag ifNotNil: [ :tag | 
			self setTag: tag onAttribute: aMiCoMethod.
			^ self ].
	].
	(groupsByTag size = 1 and: [ groupsByTag keys anyOne isNil])
		ifTrue: [ self setTag: nil onAttribute: aMiCoMethod. ]
		ifFalse: [ self setTag: conflictTag onAttribute: aMiCoMethod].
	
	
	
	
	
]

{ #category : #private }
MiCoMarkManager >> changeTagsDuring: aBlockClosure [
	| lastTag |
	lastTag := self lastTagSelected.
	aBlockClosure value.
	self lastTagSelected: lastTag
]

{ #category : #events }
MiCoMarkManager >> clickOn: aRSMouseClick [ 
	aRSMouseClick commandKeyPressed ifFalse: [ ^ self ].
	lastTagSelected ifNil: [ ^ self ].
	self setTag: lastTagSelected onAttribute: aRSMouseClick shape model.
	aRSMouseClick signalUpdate
]

{ #category : #accessing }
MiCoMarkManager >> coUsageMap [
	^ coUsageMap
]

{ #category : #accessing }
MiCoMarkManager >> coUsageMap: aMiCoCoUsageMapVisualization [
	coUsageMap := aMiCoCoUsageMapVisualization
]

{ #category : #accessing }
MiCoMarkManager >> conflictTag [
	^ self coUsageMap legendTag conflictTag
]

{ #category : #'building - menus' }
MiCoMarkManager >> contractLabel: aString [
	| contractor |
	contractor := LbCContractor new.
	contractor  addStrategy: (LbCEllipsisStrategy new 
		separator: '...';
		upTo: 50;
		yourself).
	^ contractor reduce: aString
]

{ #category : #'building - menus' }
MiCoMarkManager >> createGlobalMenuOn: menu [
	(menu
		add: 'Automatic color methods'
			target: self
			selector: #automaticColor
			argumentList: #())
		icon: (self iconNamed: #smallPaint).
	menu addLine.
	(menu
		add: 'Block Settings'
			target: MiCoUsageMapSettings
			selector: #openBlocksSettings
			argumentList: #())
		icon: (self iconNamed: #configuration)
	
]

{ #category : #'building - menus' }
MiCoMarkManager >> createMenuOn: menu for: aShape [
	aShape isShape
		ifTrue: [ aShape model createMenuOn: menu markManager: self ]
		ifFalse: [ self createGlobalMenuOn: menu ]
]

{ #category : #'building - menus' }
MiCoMarkManager >> iconFormFor: aMiCoTag [
	^ (FormCanvas extent: 15 asPoint)
		fillColor: aMiCoTag color;
		form
]

{ #category : #initialization }
MiCoMarkManager >> initialize [
	super initialize.
	strategies := (MiCoMarkStrategy subclasses collect: #new) sorted: [ :a :b | a order < b order ].
	menuInteraction := RSMenuActivable new
		menuDo: [ :menu :aShape | self createMenuOn: menu for: aShape ];
		yourself
]

{ #category : #accessing }
MiCoMarkManager >> lastTagSelected [
	^ lastTagSelected
]

{ #category : #accessing }
MiCoMarkManager >> lastTagSelected: aMiCoTag [ 
	lastTagSelected := aMiCoTag
]

{ #category : #hooks }
MiCoMarkManager >> onShape: aShape [
	aShape
		addInteraction: menuInteraction;
		when: RSMouseLeftClick send: #clickOn: to: self.
]

{ #category : #public }
MiCoMarkManager >> openSettingsBrowser [
	| browser window |
	browser := SettingBrowser new
		changePackageSet: (RPackage organizer 
		packageNamed: MiCoUsageMapSettings package name) asOrderedCollection;
	yourself.
	window := browser open.
	window position: (self currentWorld extent - window extent) // 2.
	browser expandAll.
	^ window
]

{ #category : #dependencies }
MiCoMarkManager >> release [
	super release.
	self class instVarNames do: [ :n | self instVarNamed: n put: nil ]
]

{ #category : #public }
MiCoMarkManager >> removeTag: aMiCoTag [
	self changeTagsDuring: [ 
		self coUsageMap miMethods, self coUsageMap miAttributes
			select: [:each | each tag = aMiCoTag ]
			thenDo: [:each | self setTag: nil onAttribute: each ].
	]
]

{ #category : #public }
MiCoMarkManager >> setTag: aMicoTag onAttribute: aMicoTaggedObject [
	| color |
	aMicoTaggedObject tag: aMicoTag.
	self lastTagSelected: aMicoTag.
	color := self tagColorFrom: aMicoTag.
	(self coUsageMap canvas deepShapesFromModel: aMicoTaggedObject) 
		do: [ :shape | shape color: color ].
	self coUsageMap canvas signalUpdate.
]

{ #category : #accessing }
MiCoMarkManager >> strategies [
	^ strategies
]

{ #category : #'building - menus' }
MiCoMarkManager >> subMenuTagsFor: aMiCoAttribute subMenu: menu [
	self coUsageMap legendTag tags
		select: [ :aMiCoTag | aMiCoTag isHidden not ]
		thenDo: [ :aMiCoTag |
			(menu 
				add: aMiCoTag name
					target: self
					selector: #setTag:onAttribute:
					argumentList: { aMiCoTag. aMiCoAttribute })
				icon: (self iconFormFor: aMiCoTag) ].
		aMiCoAttribute tag ifNotNil: [ 
			menu addLine.
			(menu 
				add: 'Remove tag'
					target: self
					selector: #setTag:onAttribute:
					argumentList: { nil. aMiCoAttribute })
				icon: (self iconNamed: 'remove')
			 ].
	^ menu
]

{ #category : #accessing }
MiCoMarkManager >> tagColorFrom: aMicoTag [
	aMicoTag ifNil: [ ^ Color colorFrom: 'f5f5f5' ].
	^ aMicoTag color
]

{ #category : #public }
MiCoMarkManager >> threshold75: aNumber [
	self strategies 
		detect: [ :strat | strat class = MiCo75PercentageMarkStrategy ]
		ifFound: [ :strat | strat threshold: aNumber ]
		ifNone: [  ]
]
