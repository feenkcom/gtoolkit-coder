Class {
	#name : #RBAddPackageChange,
	#superclass : #RBPackageChange,
	#category : #'GToolkit-Coder-Refactorings'
}

{ #category : #converting }
RBAddPackageChange >> asUndoOperation [
	^ RBRemovePackageChange packageName: packageName
]

{ #category : #private }
RBAddPackageChange >> primitiveExecute [
	RPackageOrganizer default createPackageNamed: packageName
]
