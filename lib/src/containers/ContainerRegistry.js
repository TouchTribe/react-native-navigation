import { AppRegistry } from 'react-native';
import ContainerWrapper from './ContainerWrapper';

export default class ContainerRegistry {
  constructor(store) {
    this.store = store;
  }

  registerContainer(containerName, getContainerFunc, Provider, store) {
    const OriginalContainer = getContainerFunc();
    const NavigationContainer = ContainerWrapper.wrap(containerName, OriginalContainer, this.store, Provider, store);
    this.store.setOriginalContainerClassForName(containerName, OriginalContainer);
    AppRegistry.registerComponent(containerName, () => NavigationContainer);
  }
}
