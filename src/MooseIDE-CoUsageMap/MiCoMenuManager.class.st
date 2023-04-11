"
I create a menu for each element and the main canvas in MiCoUsageMapBuilder.
"
Class {
	#name : #MiCoMenuManager,
	#superclass : #RSInteraction,
	#instVars : [
		'mapBuilder'
	],
	#category : #'MooseIDE-CoUsageMap-Roassal3'
}

{ #category : #hooks }
MiCoMenuManager >> clickOn: aRSMouseClick [ 
	aRSMouseClick metaKeyPressed
	  ifFalse: [ ^ self ].
	mapBuilder specModel quickTaggingOn: aRSMouseClick shape model.
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
		add: 'Auto-coloring containers'
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
		addTitle:
			aMiCoBox type , ': <' , (self contractLabel: aMiCoBox name) , '>';
		add: 'Tags'
		subMenu: (self fillTagMenu: MenuMorph new for: aMiCoBox);
		add: 'Inspect' target: aMiCoBox selector: #mooseInspect
]

{ #category : #'building - menus' }
MiCoMenuManager >> createMenu: menu onShape: aShape [
	aShape isShape
		ifTrue: [ self createMenu: menu onBox: aShape model ]
		ifFalse: [ self createGlobalMenuOn: menu ]
]

{ #category : #initialization }
MiCoMenuManager >> defaultMenuInteraction [

	^ RSMenuActivable new
		  menuDo: [ :menu :aShape | self createMenu: menu onShape: aShape ];
		  yourself
]

{ #category : #'building - menus' }
MiCoMenuManager >> fillTagMenu: menu for: aMiCoBox [
	"Fill #menu on #aMiCoBox with all tag names (not hidden tags)"
	self mapBuilder tags
		select: [ :aTag | aTag isHidden not ]
		thenDo: [ :aTag |
			(menu 
				add: aTag name
					target: (mapBuilder specModel)
					selector: #setTag:onInnerBox:
					argumentList: { aTag . aMiCoBox })
				icon: (self iconFormFor: aTag) ].
		aMiCoBox tag ifNotNil: [ 
			menu addLine.
			(menu 
				add: 'Remove tag'
					target: mapBuilder
					selector: #setTag:onInnerBox:
					argumentList: { nil. aMiCoBox })
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
		addInteraction: self defaultMenuInteraction ;
		when: RSMouseLeftClick send: #clickOn: to: self
]

{ #category : #dependencies }
MiCoMenuManager >> release [
	super release.
	self class instVarNames do: [ :n | self instVarNamed: n put: nil ]
]
