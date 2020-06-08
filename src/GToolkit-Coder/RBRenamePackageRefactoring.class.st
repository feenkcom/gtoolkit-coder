Class {
	#name : #RBRenamePackageRefactoring,
	#superclass : #RBRefactoring,
	#instVars : [
		'oldName',
		'newName'
	],
	#category : #'GToolkit-Coder-Refactorings'
}

{ #category : #'instance creation' }
RBRenamePackageRefactoring class >> from: oldName to: newName [
	^ self new
		from: oldName to: newName;
		yourself
]

{ #category : #'initialize-release' }
RBRenamePackageRefactoring >> from: oldPackageName to: newPackageName [
	oldName := oldPackageName.
	newName := newPackageName
]

{ #category : #accessing }
RBRenamePackageRefactoring >> preconditions [
	^ ((RBCondition
		withBlock: [ (RPackage organizer packageNamed: oldName asSymbol ifAbsent: [  ])
				notNil ]) errorMacro: 'Package ' , oldName , ' does not exist')
		&
			((RBCondition
				withBlock: [ (RPackage organizer packageNamed: newName asSymbol ifAbsent: [  ])
						isNil ]) errorMacro: 'Package ' , newName , ' already exists')
]

{ #category : #transforming }
RBRenamePackageRefactoring >> renameBaselineReferences [
	| rewriter baselineClass |
	baselineClass := self model classNamed: #BaselineOf.
	baselineClass isNil
		ifTrue: [ ^ self ].
	rewriter := RBParseTreeRewriter new.
	rewriter replace: oldName asString storeString with: newName asString storeString.
	self model
		allReferencesTo: oldName asString
		do: [ :method | 
			(method modelClass includesClass: baselineClass)
				ifTrue: [ (rewriter executeTree: method ast)
						ifTrue: [ method compileTree: rewriter tree ] ] ]
]

{ #category : #transforming }
RBRenamePackageRefactoring >> renamePackage [
	self model changes
		addChange: (RBRenamePackageChange from: oldName to: newName)
]

{ #category : #transforming }
RBRenamePackageRefactoring >> transform [
	self renamePackage.
	self renameBaselineReferences
]
