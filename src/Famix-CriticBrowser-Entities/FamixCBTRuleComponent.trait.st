"
I allow a rule component to be named and summarized.
"
Trait {
	#name : #FamixCBTRuleComponent,
	#instVars : [
		'#parent => FMOne type: #FamixCBContext opposite: #children',
		'#summary => FMProperty'
	],
	#traits : 'FamixTNamedEntity',
	#classTraits : 'FamixTNamedEntity classTrait',
	#category : #'Famix-CriticBrowser-Entities-Traits'
}

{ #category : #meta }
FamixCBTRuleComponent classSide >> annotation [

	<FMClass: #TRuleComponent super: #Object>
	<package: #'Famix-CriticBrowser-Entities'>
	<generated>
	^ self
]

{ #category : #ston }
FamixCBTRuleComponent classSide >> stonAllInstVarNames [ 
	^ super stonAllInstVarNames \ {#mooseID . #cache . #entityAttributes . #mooseName . #mooseModel . #entities . #violations . #contexts . #parent . #children }
]

{ #category : #accessing }
FamixCBTRuleComponent >> allParents [

	^ parent
		  ifNil: [ {  } ]
		  ifNotNil: [ self allParentsIn: OrderedCollection new ]
]

{ #category : #accessing }
FamixCBTRuleComponent >> allParentsIn: anOrderedCollection [

	^ parent ifNil: [ anOrderedCollection ] ifNotNil: [
		  anOrderedCollection add: self parent.
		  self parent allParentsIn: anOrderedCollection ]
]

{ #category : #accessing }
FamixCBTRuleComponent >> parent [
	"Relation named: #parent type: #FamixCBContext opposite: #children"

	<generated>
	<FMComment: 'Parent context, if it exists.'>
	^ parent
]

{ #category : #accessing }
FamixCBTRuleComponent >> parent: anObject [

	<generated>
	parent := anObject
]

{ #category : #removing }
FamixCBTRuleComponent >> removeSelfFromTree [

	self parent removeChild: self
]

{ #category : #initialization }
FamixCBTRuleComponent >> setParentToNilIfNeeded [

	parent ifNotNil: [ self parent: nil ] 
]

{ #category : #accessing }
FamixCBTRuleComponent >> summary [

	<FMProperty: #summary type: #String>
	<generated>
	<FMComment: 'A rule component can have an explanatory summary'>
	^ summary
]

{ #category : #accessing }
FamixCBTRuleComponent >> summary: anObject [
	<generated>
	summary := anObject
]
