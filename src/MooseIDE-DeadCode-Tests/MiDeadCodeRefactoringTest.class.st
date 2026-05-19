Class {
	#name : 'MiDeadCodeRefactoringTest',
	#superclass : 'MiAbstractDeadCodeBrowserTest',
	#category : 'MooseIDE-DeadCode-Tests',
	#package : 'MooseIDE-DeadCode-Tests'
}

{ #category : 'accessing - attributes' }
MiDeadCodeRefactoringTest >> browserRefactorButtonPresenter [

	^(browser presenterAt: #resultColumn)
		presenterAt: #btnRefactor
]

{ #category : 'running' }
MiDeadCodeRefactoringTest >> populateBrowser: mooseModel [

	super populateBrowser: mooseModel.

	mooseModel rootFolder: (FileSystem memory root)
]

{ #category : 'tests' }
MiDeadCodeRefactoringTest >> testDisabledRefactorButtonAfterRefactor [
	"'Refactor' button disabled after doing the refactoring"

	| mooseModel |
	mooseModel := FamixStModel new.
	self populateBrowser: mooseModel.

	browser specModel deadEntities addAll: mooseModel allModelMethods.
	browser updateDeadEntities.

	self assert: self browserRefactorButtonPresenter isEnabled.
	browser specModel refactorCode.

	self deny: self browserRefactorButtonPresenter isEnabled
]

{ #category : 'tests' }
MiDeadCodeRefactoringTest >> testDisabledRunButtonAfterRefactor [
	"'Run' button disabled after doing the refactoring"

	| mooseModel |
	mooseModel := FamixStModel new.
	self populateBrowser: mooseModel.

	browser specModel deadEntities addAll: mooseModel allModelMethods.
	browser updateDeadEntities.

	self assert: self browserRunButtonPresenter isEnabled.
	browser specModel refactorCode.

	self deny: self browserRunButtonPresenter isEnabled
]
