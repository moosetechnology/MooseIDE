Class {
	#name : 'MiDeadCodeBrowserTest',
	#superclass : 'MiAbstractBrowserTest',
	#category : 'MooseIDE-DeadCode-Tests',
	#package : 'MooseIDE-DeadCode-Tests'
}

{ #category : 'running' }
MiDeadCodeBrowserTest >> browserCandidateEntitiesLabelPresenter [

	^browser presenterAt: #lblAllMethods
]

{ #category : 'running' }
MiDeadCodeBrowserTest >> browserCandidateEntitiesListPresenter [

	^browser presenterAt: #lstMethod
]

{ #category : 'running' }
MiDeadCodeBrowserTest >> browserChooseHeuristicsButtonPresenter [

	^(browser presenterAt: #heuristicColumn)
		presenterAt: #btnChooseHeuristics
]

{ #category : 'running' }
MiDeadCodeBrowserTest >> browserChosenHeuristicsListPresenter [

	^(browser presenterAt: #heuristicColumn)
		presenterAt: #lstChosenHeuristics
]

{ #category : 'running' }
MiDeadCodeBrowserTest >> browserClass [

	^MiDeadCodeBrowser
]

{ #category : 'running' }
MiDeadCodeBrowserTest >> browserDeadEntitiesLabelPresenter [

	^(browser presenterAt: #resultColumn)
		presenterAt: #lblDeadMethods
]

{ #category : 'running' }
MiDeadCodeBrowserTest >> browserDeadEntitiesListPresenter [

	^(browser presenterAt: #resultColumn)
		presenterAt: #lstDeadMethods
]

{ #category : 'running' }
MiDeadCodeBrowserTest >> browserFirstRoundButtonPresenter [

	^(browser presenterAt: #resultColumn)
		presenterAt: #btnFirstRound
]

{ #category : 'running' }
MiDeadCodeBrowserTest >> browserOfferedHeuristicsListPresenter [

	^(browser presenterAt: #heuristicColumn)
		presenterAt: #lstOfferedHeuristics
]

{ #category : 'running' }
MiDeadCodeBrowserTest >> browserRecursiveRoundButtonPresenter [

	^(browser presenterAt: #resultColumn)
		presenterAt: #btnRecursive
]

{ #category : 'running' }
MiDeadCodeBrowserTest >> browserUnChooseHeuristicsButtonPresenter [

	^(browser presenterAt: #heuristicColumn)
		presenterAt: #btnRejectHeuristic
]

{ #category : 'running' }
MiDeadCodeBrowserTest >> populateBrowser: mooseModel [

	mooseModel newMethodNamed: 'aMethod'.
	mooseModel newMethodNamed: 'anotherMethod'.
	mooseModel newInvocation
		sender: (mooseModel entityNamed: 'aMethod') ;
		candidates: { mooseModel entityNamed: 'anotherMethod' }.

	browser followEntity: mooseModel allMethods.

]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testActivateActionButtons [
	"can only propagate dead methods, therefore receiving entities alone
	 does not allow to propagae anything"

	browser actionButtons do: [ :button | self deny: button isEnabled ].

	self receiveEntityToSelect.

	browser actionButtons do: [ :button | self deny: button isEnabled ]
]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testActivateRecursiveRoundButton [

	self deny: self browserRecursiveRoundButtonPresenter isEnabled.

	browser specModel deadEntities addAll: { FamixStMethod new . FamixStMethod new }.
	browser updateDeadEntities.

	self assert: self browserRecursiveRoundButtonPresenter isEnabled.

]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testAllDeadEntitiesAreMiSelected [

	self assert: browser miSelectedItem size equals: 0.

	browser specModel deadEntities addAll: { FamixStMethod new . FamixStMethod new }.
	browser updateDeadEntities.

	self assert: browser miSelectedItem size equals: 2.

]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testButtonChooseHeuristics [
	"by default, there is only one chosen heuristics
	 Select anyOne and add it to the chosen
	 Note: works because the first heuristic is not the default one"

	| heuristicToSelect itemToSelect numberChosen |

	heuristicToSelect := (browser specModel availableHeuristics \ browser specModel chosenHeuristics)
		anyOne.
	itemToSelect := self browserOfferedHeuristicsListPresenter items
		detect: [ :item |
			item heuristic = heuristicToSelect ].

	numberChosen := browser specModel chosenHeuristics size.

	self browserOfferedHeuristicsListPresenter selectItem: itemToSelect.
	self browserChooseHeuristicsButtonPresenter click.

	self assert: browser specModel chosenHeuristics size equals: numberChosen + 1
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
MiDeadCodeBrowserTest >> testChoosingHeuristicsResetsSelection [

	self browserOfferedHeuristicsListPresenter selectIndex: 1.

	self assert: self browserOfferedHeuristicsListPresenter selectedItems size equals: 1.

	self browserChooseHeuristicsButtonPresenter click.

	self assert: self browserOfferedHeuristicsListPresenter selectedItems size equals: 0
]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testDisabledFirstRoundButton [
	"without selected heuristics, '1st-round' button is disabled"

	browser specModel clearChosenHeuristics.
	browser updateChosenHeuristics.

	self deny: self browserFirstRoundButtonPresenter isEnabled
]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testEnabledFirstRoundButton [
	"with a selected heuristics, '1st-round' button is enabled"

	browser updateChosenHeuristics.

	self assert: self browserFirstRoundButtonPresenter isEnabled
]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testFirstRoundButtonUpdatesDeadEntitiesLabel [

	| mooseModel |
	mooseModel := FamixStModel new.
	self populateBrowser: mooseModel.

	self assert: self browserDeadEntitiesLabelPresenter label equals: '0 dead entities'.

	self browserFirstRoundButtonPresenter click.

	self assert: self browserDeadEntitiesLabelPresenter label equals: '1 dead entities'.

]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testFirstRoundButtonUpdatesDeadEntitiesList [

	| mooseModel |
	mooseModel := FamixStModel new.
	self populateBrowser: mooseModel.

	self assert: self browserDeadEntitiesListPresenter items size equals: 0.

	self browserFirstRoundButtonPresenter click.

	self assert: self browserDeadEntitiesListPresenter items size equals: 1.
	self assert: self browserDeadEntitiesListPresenter items anyOne name equals: 'aMethod'.
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
MiDeadCodeBrowserTest >> testInitializeChosenHeuristicsList [
	"by default, there is one selected heuristics: `MiDeadCodeNoIncomingInvocationHeuristic`
	 see also: MiDeadCodeAbstractHeuristic >> selectedByDefault"

	self assert: self browserChosenHeuristicsListPresenter items size equals: 1.

]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testInitializeHeuristicsList [

	self assert: self browserOfferedHeuristicsListPresenter items isNotEmpty
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
MiDeadCodeBrowserTest >> testRecursionButtonUResetsSelectedDeadEntities [
	"put the calling method in the list of dead entities
	 select it (it is 'miSelected')
	 click on 'Recursion' that adds the anotherMethod tot he deads
	 the previously selected methods should not be anymore"

	| mooseModel |
	mooseModel := FamixStModel new.
	self populateBrowser: mooseModel.
	browser specModel deadEntities add: (mooseModel entityNamed: 'aMethod').
	browser updateDeadEntities.	
	self browserDeadEntitiesListPresenter selectIndex: 1.

	self assert: browser miSelectedItem size equals: 1.

	self browserRecursiveRoundButtonPresenter enabled: true.
	self browserRecursiveRoundButtonPresenter click.

	self assert: self browserDeadEntitiesListPresenter selectedItems size equals: 0.
	self assert: browser miSelectedItem size equals: 2.

]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testRecursionButtonUpdatesDeadEntitiesLabel [
	"put calling method in the _model_'s list of dead entities
	 the browser knows nothing about it yet, so 'Recursion' button is disabled and number of dead entities is 0
	 then enable the button and click on it which updates the browser"

	| mooseModel |
	mooseModel := FamixStModel new.
	self populateBrowser: mooseModel.
	browser specModel deadEntities add: (mooseModel entityNamed: 'aMethod').

	self assert: self browserDeadEntitiesLabelPresenter label equals: '0 dead entities'.

	self browserRecursiveRoundButtonPresenter enabled: true.
	self browserRecursiveRoundButtonPresenter click.

	self assert: self browserDeadEntitiesLabelPresenter label equals: '2 dead entities'.

]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testRecursionButtonUpdatesDeadEntitiesList [
	"put calling method in the _model_'s list of dead entities
	 the browser knows nothing about it yet, so 'Recursion' button is disabled
	 then enable the button and click on it which updates the browser"

	| mooseModel |
	mooseModel := FamixStModel new.
	self populateBrowser: mooseModel.
	browser specModel deadEntities add: (mooseModel entityNamed: 'aMethod').

	self browserRecursiveRoundButtonPresenter enabled: true.
	self browserRecursiveRoundButtonPresenter click.

	self assert: self browserDeadEntitiesListPresenter items size equals: 2.
	self assert: (self browserDeadEntitiesListPresenter items anySatisfy: [ :mth | mth name = 'aMethod']).
	self assert: (self browserDeadEntitiesListPresenter items anySatisfy: [ :mth | mth name = 'anotherMethod']).
]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testUnchooseHeuristic [
	"by default, there is one selected heuristics"

	self browserChosenHeuristicsListPresenter selectIndex: 1.
	self browserUnChooseHeuristicsButtonPresenter click.

	self assert: self browserChosenHeuristicsListPresenter items size equals: 0
]
