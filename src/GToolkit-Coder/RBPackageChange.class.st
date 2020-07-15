Class {
	#name : #RBPackageChange,
	#superclass : #RBRefactoryChange,
	#instVars : [
		'packageName'
	],
	#category : #'GToolkit-Coder-Refactorings'
}

{ #category : #'instance creation' }
RBPackageChange class >> packageName: aString [
	^ self new
		packageName: aString;
		yourself
]

{ #category : #converting }
RBPackageChange >> asUndoOperation [
	^self subclassResponsibility
]

{ #category : #private }
RBPackageChange >> executeNotifying: aBlock [
	| undo |
	undo := self asUndoOperation.
	undo name: self name.
	self primitiveExecute.
	aBlock value.
	^ undo
]

{ #category : #accessing }
RBPackageChange >> package [
	^ RPackage organizer packageNamed: packageName ifAbsent: [  ]
]

{ #category : #accessing }
RBPackageChange >> packageName [
	^ packageName
]

{ #category : #accessing }
RBPackageChange >> packageName: aString [
	packageName := aString
]

{ #category : #private }
RBPackageChange >> primitiveExecute [
	^ self subclassResponsibility
]

{ #category : #accessing }
RBPackageChange >> renameChangesForClass: oldClassName to: newClassName [
]

{ #category : #accessing }
RBPackageChange >> tag [
	^ nil
]
