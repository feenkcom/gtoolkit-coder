Class {
	#name : #RBRenamePackageTagChange,
	#superclass : #RBPackageChange,
	#instVars : [
		'newName',
		'oldName'
	],
	#category : #'GToolkit-Coder-Refactorings'
}

{ #category : #'instance creation' }
RBRenamePackageTagChange class >> packageName: packageName from: oldName to: newName [
	^ (self packageName: packageName)
		oldName: oldName;
		newName: newName;
		yourself
]

{ #category : #converting }
RBRenamePackageTagChange >> asUndoOperation [
	^ self class packageName: packageName from: newName to: oldName
]

{ #category : #printing }
RBRenamePackageTagChange >> changeString [
	^ 'Rename package tag in ' , packageName , ' from ' , oldName
		, ' to ' , newName
]

{ #category : #accessing }
RBRenamePackageTagChange >> newName [
	^ newName
]

{ #category : #accessing }
RBRenamePackageTagChange >> newName: aString [
	newName := aString
]

{ #category : #accessing }
RBRenamePackageTagChange >> oldName [
	^ oldName
]

{ #category : #accessing }
RBRenamePackageTagChange >> oldName: aString [
	oldName := aString
]

{ #category : #private }
RBRenamePackageTagChange >> primitiveExecute [
	| package |
	package := RPackage organizer packageNamed: packageName asSymbol.
	(package classTagNamed: oldName asSymbol) renameTo: newName asSymbol
]
