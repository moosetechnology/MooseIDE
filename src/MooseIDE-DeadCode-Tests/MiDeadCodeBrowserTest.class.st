Class {
	#name : 'MiDeadCodeBrowserTest',
	#superclass : 'MiAbstractBrowserTest',
	#category : 'MooseIDE-DeadCode-Tests',
	#package : 'MooseIDE-DeadCode-Tests'
}

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
MiDeadCodeBrowserTest >> browserRecursiveRoundButtonPresenter [

	^(browser presenterAt: #resultColumn)
		presenterAt: #btnRecursive
]

{ #category : 'running' }
MiDeadCodeBrowserTest >> populateBrowser: mooseModel [

	mooseModel newMethodNamed: 'aMethod'.
	mooseModel newMethodNamed: 'anotherMethod'.

	browser followEntity: mooseModel entities.

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
MiDeadCodeBrowserTest >> testButtonChooseHeuristics [
	"by default, there is only one chosen heuristics
	 Select anyOne and add it to the chosen
	 Note: works because the first heuristic is not the default one"

	| heuristicToSelect itemToSelect numberChosen |

	heuristicToSelect := (browser specModel availableHeuristics \ browser specModel chosenHeuristics)
		anyOne.
	itemToSelect := browser heuristicColumn listHeuristicsOffered items
		detect: [ :item |
			item heuristic = heuristicToSelect ].

	numberChosen := browser specModel chosenHeuristics size.

	browser heuristicColumn listHeuristicsOffered selectItem: itemToSelect.
	browser heuristicColumn buttonChooseHeuristics click.

	self assert: browser specModel chosenHeuristics size equals: numberChosen + 1
]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testCanPropagateAfterDeadComputation [

	| mooseModel |
	mooseModel := FamixStModel new.
	self populateBrowser: mooseModel.

	browser specModel deadEntities addAll: self mooseObjects.

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

	browser heuristicColumn listHeuristicsOffered selectIndex: 1.

	self assert: browser heuristicColumn listHeuristicsOffered selectedItems size equals: 1.

	browser heuristicColumn buttonChooseHeuristics click.

	self assert: browser heuristicColumn listHeuristicsOffered selectedItems size equals: 0
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
MiDeadCodeBrowserTest >> testInitializeCandidateEntityList [

	| mooseModel |
	mooseModel := FamixStModel new.
	self populateBrowser: mooseModel.

	self assert: browser candidateEntities items isNotEmpty.
	self assert: browser labelCandidateEntities label equals: '2 entities'
]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testInitializeHeuristicsList [

	self assert: browser heuristicColumn listHeuristicsOffered items isNotEmpty
]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testInitializeSelectedHeuristicsList [
	"by default, there is one selected heuristics: `MiDeadCodeNoIncomingInvocationHeuristic`
	 see also: MiDeadCodeAbstractHeuristic >> selectedByDefault"

	self assert: browser heuristicColumn listHeuristicsChosen items size equals: 1.

]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testRecursionButtonUpdatesDeadEntitiesList [

	self assert: self browserDeadEntitiesListPresenter items size equals: 0.

	browser specModel deadEntities addAll: { FamixStMethod new . FamixStMethod new }.
	browser updateDeadEntities.

	self assert: self browserDeadEntitiesListPresenter items size equals: 2.
]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testUnchooseHeuristic [
	"by default, there is one selected heuristics"

	browser heuristicColumn listHeuristicsChosen selectIndex: 1.
	browser heuristicColumn buttonUnchooseHeuristics click.

	self assert: browser heuristicColumn listHeuristicsChosen items size equals: 0
]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testUpdateDeadEntitiesLabel [

	self assert: self browserDeadEntitiesLabelPresenter label equals: '0 dead entities'.

	browser specModel deadEntities addAll: { FamixStMethod new . FamixStMethod new }.
	browser updateDeadEntities.

	self assert: self browserDeadEntitiesLabelPresenter label equals: '2 dead entities'
]

{ #category : 'tests' }
MiDeadCodeBrowserTest >> testUpdateDeadEntitiesList [

	self assert: self browserDeadEntitiesListPresenter items size equals: 0.

	browser specModel deadEntities addAll: { FamixStMethod new . FamixStMethod new }.
	browser updateDeadEntities.

	self assert: self browserDeadEntitiesListPresenter items size equals: 2.
]
