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
		'mapBuilder'
	],
	#category : #'MooseIDE-CoUsageMap-Roassal3'
}

{ #category : #hooks }
MiCoMenuManager >> clickOn: aRSMouseClick [ 
	aRSMouseClick metaKeyPressed
	  ifFalse: [ ^ self ].
	mapBuilder quickTaggingOn: aRSMouseClick shape model.
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
			target: mapBuilder
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
			subMenu: (self fillTagMenuFor: aMiCoBox inMenu: MenuMorph new);
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
MiCoMenuManager >> fillTagMenuFor: innerBox inMenu: menu [
	"Fill #menu on #innerBox with all tags (not hidden)"
	self mapBuilder tags
		select: [ :aTag | aTag isHidden not ]
		thenDo: [ :aTag |
			(menu 
				add: aTag name
					target: mapBuilder
					selector: #setTag:onAttribute:
					argumentList: { aTag . innerBox })
				icon: (self iconFormFor: aTag) ].
		innerBox tag ifNotNil: [ 
			menu addLine.
			(menu 
				add: 'Remove tag'
					target: mapBuilder
					selector: #setTag:onAttribute:
					argumentList: { nil. innerBox })
				icon: (self iconNamed: 'remove')
			 ].
	^ menu
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

	menuInteraction := RSMenuActivable new
		menuDo: [ :menu :aShape | self createMenu: menu onShape: aShape ];
		yourself
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
		when: RSMouseLeftClick send: #clickOn: to: self
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

{ #category : #accessing }
MiCoMenuManager >> specModel [
	^mapBuilder specModel
]
