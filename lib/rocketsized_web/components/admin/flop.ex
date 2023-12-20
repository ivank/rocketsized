defmodule RocketsizedWeb.Admin.Flop do
  import Phoenix.HTML.Tag

  def pagination_opts do
    [
      ellipsis_attrs: [class: "ellipsis"],
      ellipsis_content: "‥",
      next_link_attrs: [class: "next"],
      next_link_content: next_icon(),
      page_links: {:ellipsis, 7},
      pagination_link_aria_label: &"#{&1}ページ目へ",
      previous_link_attrs: [class: "prev"],
      previous_link_content: previous_icon()
    ]
  end

  defp next_icon do
    tag(:i, class: "fas fa-chevron-right")
  end

  defp previous_icon do
    tag(:i, class: "fas fa-chevron-left")
  end

  def table_opts do
    [
      container: true,
      container_attrs: [class: "overflow-y-auto px-4 sm:overflow-visible sm:px-0"],
      no_results_content: content_tag(:p, do: "Nothing found."),
      table_attrs: [class: "w-[40rem] mt-11 sm:w-full"],
      thead_attrs: [class: "text-sm text-left leading-6 text-zinc-500"],
      tbody_th_attrs: [class: "p-0 pr-6 pb-4 font-normal"],
      tbody_attrs: [
        class:
          "relative divide-y divide-zinc-100 border-t border-zinc-200 text-sm leading-6 text-zinc-700"
      ],
      tbody_td_attrs: [class: "py-4 pr-6"]
    ]
  end
end
