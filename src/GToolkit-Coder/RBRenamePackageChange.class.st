Class {
	#name : #RBRenamePackageChange,
	#superclass : #RBPackageChange,
	#instVars : [
		'newPackageName'
	],
	#category : #'GToolkit-Coder-Refactorings'
}

{ #category : #'instance creation' }
RBRenamePackageChange class >> from: oldName to: newName [
	^ (self packageName: oldName)
		newPackageName: newName;
		yourself
]

{ #category : #converting }
RBRenamePackageChange >> asUndoOperation [
	^ self class from: newPackageName to: packageName
]

{ #category : #printing }
RBRenamePackageChange >> changeString [
	^ 'Rename package ' , packageName , ' to ' , newPackageName
]

{ #category : #accessing }
RBRenamePackageChange >> newPackageName [
	^ newPackageName
]

{ #category : #accessing }
RBRenamePackageChange >> newPackageName: aString [
	newPackageName := aString
]

{ #category : #private }
RBRenamePackageChange >> primitiveExecute [
	| package |
	package := RPackage organizer packageNamed: packageName asSymbol.
	package renameTo: newPackageName asSymbol
]
