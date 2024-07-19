"
I allow a rule component to be named and summarized.

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `ruleContainer` | `FamixCBTRuleComponent` | `ruleComponents` | `FamixCBTRuleComposite` | Parent context, if it exists.|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `summary` | `String` | nil | A rule component can have an explanatory summary|

"
Trait {
	#name : #FamixCBTRuleComponent,
	#instVars : [
		'#ruleContainer => FMOne type: #FamixCBTRuleComposite opposite: #ruleComponents',
		'#summary => FMProperty'
	],
	#traits : 'FamixTNamedEntity + TEntityMetaLevelDependency',
	#classTraits : 'FamixTNamedEntity classTrait + TEntityMetaLevelDependency classTrait',
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
FamixCBTRuleComponent >> parent [

	self
		deprecated: ''
		transformWith: '`@receiver parent' -> '`@receiver ruleContainer'.

	^ self ruleContainer
]

{ #category : #accessing }
FamixCBTRuleComponent >> parent: anObject [

	self
		deprecated: ''
		transformWith:
		'`@receiver parent: `@arg' -> '`@receiver ruleContainer: `@arg'.

	^ self ruleContainer: anObject
]

{ #category : #removing }
FamixCBTRuleComponent >> removeSelfFromTree [

	self ruleContainer removeChild: self
]

{ #category : #accessing }
FamixCBTRuleComponent >> ruleContainer [
	"Relation named: #ruleContainer type: #FamixCBTRuleComposite opposite: #ruleComponents"

	<generated>
	<FMComment: 'Parent context, if it exists.'>
	<container>
	^ ruleContainer
]

{ #category : #accessing }
FamixCBTRuleComponent >> ruleContainer: anObject [

	<generated>
	ruleContainer := anObject
]

{ #category : #navigation }
FamixCBTRuleComponent >> ruleContainerGroup [
	<generated>
	<navigation: 'RuleContainer'>
	^ MooseSpecializedGroup with: self ruleContainer
]

{ #category : #initialization }
FamixCBTRuleComponent >> setParentToNilIfNeeded [

	self ruleContainer ifNotNil: [ self ruleContainer: nil ]
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
