Class {
	#name : 'MiDeadCodeBrowserTest',
	#superclass : 'MiAbstractDeadCodeBrowserTest',
	#category : 'MooseIDE-DeadCode-Tests',
	#package : 'MooseIDE-DeadCode-Tests'
}

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testActivateActionButtons [
	"can only propagate dead methods, therefore receiving entities alone
	 does not allow to propagate anything"

	browser actionButtons do: [ :button | self deny: button isEnabled ].

	self receiveEntityToSelect.

	browser actionButtons do: [ :button | self deny: button isEnabled ]
]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testAllDeadEntitiesAreMiSelected [

	self assert: browser miSelectedItem size equals: 0.

	browser specModel deadEntities addAll: { FamixStMethod new . FamixStMethod new }.
	browser updateDeadEntities.

	self assert: browser miSelectedItem size equals: 2.

]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testButtonChooseRules [
	"by default, there is only one chosen rule
	 Select anyOne and add it to the chosen"

	| numberChosen |
	numberChosen := browser specModel chosenRules size.

	self selectOfferedRule: MiDeadTestNamingConventionRule.
	self browserChooseRulesButtonPresenter click.

	self assert: browser specModel chosenRules size equals: numberChosen + 1
]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testCanPropagateAfterDeadComputation [

	| mooseModel |
	mooseModel := FamixStModel new.
	self populateBrowser: mooseModel.

	browser specModel deadEntities addAll: mooseModel allMethods.

	self assert: browser canPropagate.

]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testCannotPropagateAtInitialization [

	| mooseModel |
	mooseModel := FamixStModel new.
	self populateBrowser: mooseModel.

	self deny: browser canPropagate.

]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testChoosingRuleGroup [
	"Choose the first group which is 'Java' containing 6 rules"

	self selectOfferedRule: Association.
	
	self assert: browser specModel chosenRules size equals: 1.

	self browserChooseRulesButtonPresenter click.

	self assert: browser specModel chosenRules size equals: 7
]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testChoosingRulesResetsSelection [

	self selectOfferedRule: MiDeadTestNamingConventionRule.

	self assert: self browserOfferedRuleTreePresenter selectedItems size equals: 1.

	self browserChooseRulesButtonPresenter click.

	self assert: self browserOfferedRuleTreePresenter selectedItems size equals: 0
]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testClearButtonEmptiesDeadEntityList [

	| mooseModel |
	mooseModel := FamixStModel new.
	self populateBrowser: mooseModel.
	browser specModel deadEntities add: (mooseModel entityNamed: 'aMethod').
	browser updateDeadEntities.

	self assert: self browserDeadEntitiesListPresenter items size equals: 1.

	self browserClearDeadButtonPresenter click.

	self assert: self browserDeadEntitiesListPresenter items size equals: 0
]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testDisabledRunButton [
	"without selected heuristics, 'Run' button is disabled"

	browser specModel clearChosenRules.
	browser updateChosenRules.

	self deny: self browserRunButtonPresenter isEnabled
]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testEnabledRunButton [
	"with a selected heuristics, 'Run' button is enabled"

	browser updateChosenRules.

	self assert: self browserRunButtonPresenter isEnabled
]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testInitializeCandidateEntityLabel [

	| mooseModel |
	mooseModel := FamixStModel new.
	self populateBrowser: mooseModel.

	self assert: self browserCandidateEntitiesLabelPresenter label equals: '2 entities'
]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testInitializeCandidateEntityList [

	| mooseModel |
	mooseModel := FamixStModel new.
	self populateBrowser: mooseModel.

	self assert: self browserCandidateEntitiesListPresenter items size equals: 2
]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testInitializeChosenRuleList [
	"by default, there is one selected heuristics: `MiDeadCodeNoIncomingInvocationHeuristic`
	 see also: MiDeadCodeAbstractHeuristic >> selectedByDefault"

	self assert: self browserChosenRulesTreePresenter items size equals: 1.

]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testInitializeOfferedRuleTree [

	self assert: self browserOfferedRuleTreePresenter roots isNotEmpty
]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testOnlySelectedDeadEntitiesAreMiSelected [
	"If one entity is selected in result column, only this one is miSelected"

	self assert: browser miSelectedItem size equals: 0.

	browser specModel deadEntities addAll: { FamixStMethod new . FamixStMethod new }.
	browser updateDeadEntities.

	self browserDeadEntitiesListPresenter selectIndex: 1.

	self assert: browser miSelectedItem size equals: 1.

]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testRunButtonUpdatesDeadEntitiesLabel [

	| mooseModel |
	mooseModel := FamixStModel new.
	self populateBrowser: mooseModel.

	self assert: self browserDeadEntitiesLabelPresenter label equals: '0 dead entities'.

	self browserRunButtonPresenter click.

	self assert: self browserDeadEntitiesLabelPresenter label equals: '2 dead entities'.

]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testRunButtonUpdatesDeadEntitiesList [

	| mooseModel |
	mooseModel := FamixStModel new.
	self populateBrowser: mooseModel.

	self assert: self browserDeadEntitiesListPresenter items size equals: 0.

	self browserRunButtonPresenter click.

	self
		assertCollection: self browserDeadEntitiesListPresenter items
		hasSameElements: { mooseModel entityNamed: 'aMethod' . mooseModel entityNamed: 'anotherMethod' }
]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testRunDoesNotAddOutsideFollowedEntities [
	"Recursion step cannot add dead entities outside of the initial list of followed entities
	 here 'aThirdDeadMethod' is dead, but not followed"

	| mooseModel |
	mooseModel := FamixStModel new.
	self populateBrowser: mooseModel.

	mooseModel newMethodNamed: 'aThirdDeadMethod'.
	mooseModel newInvocation
		sender: (mooseModel entityNamed: 'aMethod') ;
		candidates: { mooseModel entityNamed: 'aThirdDeadMethod' }.

	self browserRunButtonPresenter click.

	self
		assertCollection: self browserDeadEntitiesListPresenter items
		hasSameElements: { mooseModel entityNamed: 'aMethod' . mooseModel entityNamed: 'anotherMethod' }
]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testUnchooseHeuristic [
	"by default, there is one selected heuristics"

	self browserChosenRulesTreePresenter selectIndex: 1.
	self browserUnChooseRulesButtonPresenter click.

	self assert: self browserChosenRulesTreePresenter items size equals: 0
]
