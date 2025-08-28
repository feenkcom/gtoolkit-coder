Trait {
	#name : #TGtCoderViewModelWithParentProperties,
	#category : #'GToolkit-Coder-UI-Coder - Basic'
}

{ #category : #accessing }
TGtCoderViewModelWithParentProperties >> parentCoderViewModel [
	^ self
		optionAt: #parentCoderViewModel
		ifPresent: [ :aWeak | aWeak at: 1 ]
		ifAbsent: [ nil ]
]

{ #category : #accessing }
TGtCoderViewModelWithParentProperties >> parentCoderViewModel: aCoderViewModel [
	"In case of method coders expanded inside of another method coder,
	the parent-method-coder view model is set, to be able to get an extra information."
	
	self 
		optionAt: #parentCoderViewModel 
		put: aCoderViewModel asWeakReference
]

{ #category : #accessing }
TGtCoderViewModelWithParentProperties >> parentExample [
	<return: #GtExampleWithResult or: nil>
	^ self
		optionAt: #parentExample
		ifPresent: [ :aWeak | aWeak at: 1 ]
		ifAbsent: [ nil ]
]

{ #category : #accessing }
TGtCoderViewModelWithParentProperties >> parentExample: anExample [
	"In case of method coders expanded inside of another method coder,
	the parent-method-coder example is set, to be able to highlight failing code
	in those expanded method coders."
	
	self 
		optionAt: #parentExample 
		put: anExample asWeakReference
]

{ #category : #accessing }
TGtCoderViewModelWithParentProperties >> parentTestCase [
	^ self
		optionAt: #parentTestCase
		ifPresent: [ :aWeak | aWeak at: 1 ]
		ifAbsent: [ nil ]
]

{ #category : #accessing }
TGtCoderViewModelWithParentProperties >> parentTestCase: aTestCase [
	"In case of method coders expanded inside of another method coder,
	the parent-method-coder test case is set, to be able to highlight failing code
	in those expanded method coders."

	self 
		optionAt: #parentTestCase 
		put: aTestCase asWeakReference
]
