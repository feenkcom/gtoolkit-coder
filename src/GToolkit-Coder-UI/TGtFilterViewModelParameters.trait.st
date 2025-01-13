Trait {
	#name : #TGtFilterViewModelParameters,
	#category : #'GToolkit-Coder-UI-Filters - View Models'
}

{ #category : #accessing }
TGtFilterViewModelParameters >> parameters [
	<return: #Collection of: #GtFilterModelParameter>
	^ self filterModel parameters
]
