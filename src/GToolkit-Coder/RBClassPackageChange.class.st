Class {
	#name : #RBClassPackageChange,
	#superclass : #RBClassCategoryChange,
	#category : #'GToolkit-Coder-Refactorings'
}

{ #category : #private }
RBClassPackageChange >> primitiveExecute [
	| class |
	class := self changeClass.
	class classInstaller
		update: class
		to: [ :builder | 
			builder
				fillFor: class;
				category: category ]
]
