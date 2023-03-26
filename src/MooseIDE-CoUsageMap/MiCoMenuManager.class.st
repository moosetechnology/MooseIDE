"
I create a menu for each element and the main canvas in MiCoUsageMapBuilder.
Mark means, put a tag into an attribute or method.
My resposability is automatize the marking process for methods.
Check automaticColor
Related to MiCoMarkStrategy
"
Class {
	#name : #MiCoMenuManager,
	#superclass : #RSInteraction,
	#instVars : [
		'menuInteraction',
		'strategies',
		'lastTagSelected',
		'mapBuilder'
	],
	#category : #'MooseIDE-CoUsageMap-Roassal3'
}

{ #category : #public }
MiCoMenuManager >> automaticColor [
	self changeTagsDuring: [ 
		self mapBuilder miMethods 
			do:[:met | self automaticColorForMethod: met ].
	]
	
]

{ #category : #public }
MiCoMenuManager >> automaticColorForMethod: aMiCoMethod [
	| groupsByTag |
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
	self setTag: nil onAttribute: aMiCoMethod.
	
	
	
	
	
]

{ #category : #private }
MiCoMenuManager >> changeTagsDuring: aBlockClosure [
	| lastTag |
	lastTag := self lastTagSelected.
	aBlockClosure value.
	self lastTagSelected: lastTag
]

{ #category : #events }
MiCoMenuManager >> clickOn: aRSMouseClick [ 
	aRSMouseClick metaKeyPressed ifFalse: [ ^ self ].
	lastTagSelected ifNil: [ ^ self ].
	self setTag: lastTagSelected onAttribute: aRSMouseClick shape model.
	aRSMouseClick signalUpdate
]

{ #category : #'building - menus' }
MiCoMenuManager >> contractLabel: aString [
	| contractor |
	contractor := LbCContractor new.
	contractor  addStrategy: (LbCEllipsisStrategy new 
		separator: '...';
		upTo: 50;
		yourself).
	^ contractor reduce: aString
]

{ #category : #'building - menus' }
MiCoMenuManager >> createGlobalMenuOn: menu [
	(menu
		add: 'Automatic color methods'
			target: self
			selector: #automaticColor
			argumentList: #())
		icon: (self iconNamed: #smallPaint).
	menu addLine.
	(menu
		add: 'Settings'
			target: mapBuilder visualization
			selector: #openSettings
			argumentList: #())
		icon: (self iconNamed: #configuration)
	
]

{ #category : #'building - menus' }
MiCoMenuManager >> createMenu: aMenuMorph onBox: aMiCoBox [
	aMenuMorph
		addTitle: aMiCoBox type, ': <', (self contractLabel: aMiCoBox name),'>';
		add: 'Tags' 
			subMenu: (self subMenuTagsFor: aMiCoBox subMenu: MenuMorph new);
		add: 'Inspect'
			target: aMiCoBox
			selector: #mooseInspect
]

{ #category : #'building - menus' }
MiCoMenuManager >> createMenu: menu onShape: aShape [
	aShape isShape
		ifTrue: [ self createMenu: menu onBox: aShape model ]
		ifFalse: [ self createGlobalMenuOn: menu ]
]

{ #category : #'building - menus' }
MiCoMenuManager >> iconFormFor: aMiCoTag [
	^ (FormCanvas extent: 15 asPoint)
		fillColor: aMiCoTag color;
		form
]

{ #category : #initialization }
MiCoMenuManager >> initialize [
	super initialize.
	strategies := (MiCoMarkStrategy subclasses collect: #new) sorted: [ :a :b | a order < b order ].
	menuInteraction := RSMenuActivable new
		menuDo: [ :menu :aShape | self createMenu: menu onShape: aShape ];
		yourself
]

{ #category : #accessing }
MiCoMenuManager >> lastTagSelected [
	^ lastTagSelected
]

{ #category : #accessing }
MiCoMenuManager >> lastTagSelected: aMiCoTag [ 
	lastTagSelected := aMiCoTag
]

{ #category : #accessing }
MiCoMenuManager >> mapBuilder [

	^ mapBuilder
]

{ #category : #accessing }
MiCoMenuManager >> mapBuilder: anObject [

	mapBuilder := anObject
]

{ #category : #hooks }
MiCoMenuManager >> onShape: aShape [
	aShape
		addInteraction: menuInteraction;
		when: RSMouseLeftClick send: #clickOn: to: self.
]

{ #category : #dependencies }
MiCoMenuManager >> release [
	super release.
	self class instVarNames do: [ :n | self instVarNamed: n put: nil ]
]

{ #category : #public }
MiCoMenuManager >> removeTag: aMiCoTag [
	self changeTagsDuring: [ 
		self mapBuilder miMethods, self mapBuilder miAttributes
			select: [:each | each tag = aMiCoTag ]
			thenDo: [:each | self setTag: nil onAttribute: each ].
	]
]

{ #category : #public }
MiCoMenuManager >> setTag: aMicoTag onAttribute: aMicoTaggedObject [
	| color |
	(aMicoTaggedObject tag: aMicoTag)
	ifNotNil: [ :tagAssociation |
		self mapBuilder specModel currentApplication consumeItem: tagAssociation ].
	self lastTagSelected: aMicoTag.
	color := self tagColorFrom: aMicoTag.
	(self mapBuilder canvas deepShapesFromModel: aMicoTaggedObject) 
		do: [ :shape | shape color: color ].
	self mapBuilder canvas signalUpdate.
]

{ #category : #accessing }
MiCoMenuManager >> strategies [
	^ strategies
]

{ #category : #'building - menus' }
MiCoMenuManager >> subMenuTagsFor: aMiCoAttribute subMenu: menu [
	self mapBuilder tags
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
MiCoMenuManager >> tagColorFrom: aMiCoTag [
	(aMiCoTag isNil or: [aMiCoTag isHidden ]) ifTrue: [ ^ Color colorFrom: 'f5f5f5' ].
	^ aMiCoTag color
]

{ #category : #public }
MiCoMenuManager >> threshold75: aNumber [
	self strategies 
		detect: [ :strat | strat class = MiCo75PercentageMarkStrategy ]
		ifFound: [ :strat | strat threshold: aNumber ]
		ifNone: [  ]
]
