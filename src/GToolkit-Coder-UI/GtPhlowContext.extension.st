Extension { #name : #GtPhlowContext }

{ #category : #'*GToolkit-Coder-UI' }
GtPhlowContext >> coderCompiledMethod: aCompiledMethod [
	self optionAt: #coderCompiledMethod put: aCompiledMethod
]

{ #category : #'*GToolkit-Coder-UI' }
GtPhlowContext >> coderCompiledMethodIfPresent: aPresentBlock ifAbsent: anAbsentBlock [
	^ self
		optionAt: #coderCompiledMethod
		ifPresent: aPresentBlock
		ifAbsent: anAbsentBlock
]

{ #category : #'*GToolkit-Coder-UI' }
GtPhlowContext >> coderSelectedClass: aClass [
	self optionAt: #coderSelectedClass put: aClass
]

{ #category : #'*GToolkit-Coder-UI' }
GtPhlowContext >> coderSelectedClasses [
	^ self optionAt: #coderSelectedClasses ifAbsent: [ #() ]
]

{ #category : #'*GToolkit-Coder-UI' }
GtPhlowContext >> coderSelectedClasses: aCollectionOfClasses [
	self optionAt: #coderSelectedClasses put: aCollectionOfClasses
]

{ #category : #'*GToolkit-Coder-UI' }
GtPhlowContext >> coderSelectedClassIfPresent: aPresentBlock ifAbsent: anAbsentBlock [
	^ self
		optionAt: #coderSelectedClass
		ifPresent: aPresentBlock
		ifAbsent: anAbsentBlock
]

{ #category : #'*GToolkit-Coder-UI' }
GtPhlowContext >> coderViewModel: aCoderViewModel [
	self optionAt: #coderViewModel: put: aCoderViewModel
]

{ #category : #'*GToolkit-Coder-UI' }
GtPhlowContext >> coderViewModelIfPresent: aPresentBlock ifAbsent: anAbsentBlock [
	^ self
		optionAt: #coderViewModel
		ifPresent: aPresentBlock
		ifAbsent: anAbsentBlock
]
