"
I contain rule components

## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `ruleComponents` | `FamixCBTRuleComposite` | `ruleContainer` | `FamixCBTRuleComponent` | Every child context or condition of this context.|



"
Trait {
	#name : #FamixCBTRuleComposite,
	#instVars : [
		'#ruleComponents => FMMany type: #FamixCBTRuleComponent opposite: #ruleContainer'
	],
	#traits : 'TEntityMetaLevelDependency',
	#classTraits : 'TEntityMetaLevelDependency classTrait',
	#category : #'Famix-CriticBrowser-Entities-Traits'
}

{ #category : #meta }
FamixCBTRuleComposite classSide >> annotation [

	<FMClass: #TRuleComposite super: #Object>
	<package: #'Famix-CriticBrowser-Entities'>
	<generated>
	^ self
]

{ #category : #adding }
FamixCBTRuleComposite >> addRuleComponent: anObject [
	<generated>
	^ self ruleComponents add: anObject
]

{ #category : #accessing }
FamixCBTRuleComposite >> ruleComponents [
	"Relation named: #ruleComponents type: #FamixCBTRuleComponent opposite: #ruleContainer"

	<generated>
	<FMComment: 'Every child context or condition of this context.'>
	<derived>
	^ ruleComponents
]

{ #category : #accessing }
FamixCBTRuleComposite >> ruleComponents: anObject [

	<generated>
	ruleComponents value: anObject
]

{ #category : #navigation }
FamixCBTRuleComposite >> ruleComponentsGroup [
	<generated>
	<navigation: 'RuleComponents'>
	^ MooseSpecializedGroup withAll: self ruleComponents asSet
]
