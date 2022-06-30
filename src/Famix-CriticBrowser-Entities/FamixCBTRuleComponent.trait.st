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
	^self
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
