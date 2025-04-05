import { makeAutoObservable } from "mobx";

import repository from "../repository/PanelRespository";

// PanelStore.ts
class PanelStore {
	constructor() {
		makeAutoObservable(this);
	}

	create(request: any, onSuccess?: any, onError?: any, element?: any) {
		repository.create(request, onSuccess, onError, element);
	}
	search(request: any, onSuccess?: any, onError?: any, element?: any) {
		repository.search(request, onSuccess, onError, element);
	}
	update(request: any, onSuccess?: any, onError?: any, element?: any) {
		repository.update(request, onSuccess, onError, element);
	}
	remove(request: any, onSuccess?: any, onError?: any, element?: any) {
		repository.remove(request, onSuccess, onError, element);
	}
	batch(request: any, onSuccess?: any, onError?: any, element?: any) {
		repository.batch(request, onSuccess, onError, element);
	}
	download(request: any, onSuccess?: any, onError?: any, element?: any) {
		repository.download(request, onSuccess, onError, element);
	}
	upload(request: any, onSuccess?: any, onError?: any, element?: any) {
		repository.upload(request, onSuccess, onError, element);
	}
	deduplicate(onSuccess?: any, onError?: any, element?: any) {
		repository.deduplicate(onSuccess, onError, element);
	}

}
const store = new PanelStore();
export default store;
