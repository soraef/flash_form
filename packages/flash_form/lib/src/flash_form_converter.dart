abstract class FlashFormConverter<TModel, TFormModel> {
  TFormModel toFormModel(TModel model);
  TModel toModel(TFormModel formModel);
}
